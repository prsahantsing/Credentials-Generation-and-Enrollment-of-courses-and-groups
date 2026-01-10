function updateUsersFromLatestCSV() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const folderName = "CSV_HANDLE";

  // --- Find CSV folder ---
  const folderIterator = DriveApp.getFoldersByName(folderName);
  if (!folderIterator.hasNext()) {
    Logger.log(`❌ Folder "${folderName}" not found.`);
    return;
  }

  const folder = folderIterator.next();
  Logger.log(`📁 Found folder: ${folderName} (ID: ${folder.getId()})`);

  // --- Collect CSV files ---
  const files = [];
  const fileIter = folder.getFiles();

  while (fileIter.hasNext()) {
    const file = fileIter.next();
    const name = file.getName();

    if (name.toLowerCase().endsWith(".csv")) {
      Logger.log(`📄 Found CSV file: ${name}`);
      files.push(file);
    }
  }

  if (files.length === 0) {
    Logger.log(`⏩ No CSV files found in folder ${folderName}`);
    return;
  }

  // --- Get latest CSV ---
  files.sort((a, b) => b.getLastUpdated() - a.getLastUpdated());
  const latestFile = files[0];

  Logger.log(
    `➡ Processing latest file: ${latestFile.getName()} ` +
    `(Last updated: ${latestFile.getLastUpdated()})`
  );

  // --- Read CSV ---
  const csvContent = latestFile.getBlob().getDataAsString();
  const csvData = Utilities.parseCsv(csvContent);

  if (csvData.length < 2) {
    Logger.log("⏩ CSV does not contain enough data rows.");
    return;
  }

  const sourceHeaders = csvData[0].map(h =>
    h.toString().trim().toLowerCase()
  );
  const rows = csvData.slice(1);

  // --- Helpers ---
  function normalizeBranchName(raw) {
    let b = (raw || "").toString().trim().toLowerCase();
    b = b
      .replace(/ngs[\s\-]*(wb)?/g, "")
      .replace(/\(\w+\)/g, "")
      .trim();
    return b;
  }

  const schoolNames = [
    "Narayana Group of Schools (WB)",
    "Little Leaders",
    "Superhouse",
    "Schools"
  ];

  const ignoreSheets = [
    "Heads & Admin",
    "Educators",
    "Guidelines",
    "Course Details"
  ];

  // --- Process each CSV row ---
  for (let r = 0; r < rows.length; r++) {
    const row = rows[r];

    const getCol = (colName) => {
      const idx = sourceHeaders.indexOf(colName.toLowerCase());
      return idx !== -1 ? (row[idx] || "").toString().trim() : "";
    };

    const firstName = getCol("firstname").toLowerCase();
    const lastName = getCol("lastname").toLowerCase();
    const username = getCol("username");
    const password = getCol("password");
    const grade = getCol("class/grade").toLowerCase();
    const section = getCol("section").toLowerCase();
    const rawBranch = getCol("branch");
    const branchName = getCol("branchname").toLowerCase();
    const admissionNumber = getCol(
      "admission number / unique identification number"
    ).toLowerCase();

    Logger.log(
      `🔎 Row ${r + 1} → ${firstName} ${lastName}, ` +
      `Grade: ${grade}, Section: ${section}, Branch: ${rawBranch}`
    );

    let userUpdated = false;

    // --- Search in schools ---
    for (let s = 0; s < schoolNames.length && !userUpdated; s++) {
      const schoolName = schoolNames[s];
      const schoolSheet = ss.getSheetByName(schoolName);

      if (!schoolSheet) {
        Logger.log(`⛔ Sheet "${schoolName}" not found.`);
        continue;
      }

      const schoolData = schoolSheet.getDataRange().getValues();
      Logger.log(`📘 Searching in school: ${schoolName}`);

      const branchRow = schoolData.find(r => {
        const fullBranch = (r[1] || "").toString().trim().toLowerCase();
        return normalizeBranchName(fullBranch) === normalizeBranchName(branchName);
      });

      if (!branchRow) {
        Logger.log(`⛔ Branch "${branchName}" not found in "${schoolName}"`);
        continue;
      }

      const branchLink = branchRow[2];
      if (!branchLink || !branchLink.includes("https://")) {
        Logger.log(`⛔ Invalid branch link for "${branchName}"`);
        continue;
      }

      let branchSS;
      try {
        branchSS = SpreadsheetApp.openByUrl(branchLink);
      } catch (err) {
        Logger.log(`❌ Failed to open branch sheet: ${err.message}`);
        continue;
      }

      // --- Search branch sheets ---
      const sheets = branchSS.getSheets();
      for (let j = 0; j < sheets.length && !userUpdated; j++) {
        const sheet = sheets[j];
        const sheetName = sheet.getName().trim();

        if (
          ignoreSheets.some(ig =>
            sheetName.toLowerCase().includes(ig.toLowerCase())
          )
        ) {
          continue;
        }

        const sheetData = sheet.getDataRange().getValues();
        if (sheetData.length < 2) continue;

        const headerRowIdx = 1;
        const headers = sheetData[headerRowIdx].map(h =>
          h.toString().trim().toLowerCase()
        );

        const firstCol = headers.indexOf("first name");
        const lastCol = headers.indexOf("last name");
        const gradeCol = headers.indexOf("class/grade");
        const sectionCol = headers.indexOf("section");
        const branchCol = headers.indexOf("branch");
        const admissionCol = headers.indexOf(
          "admission number / unique identification number"
        );
        const usernameCol = headers.indexOf("username");
        const passwordCol = headers.indexOf("password");

        if (
          [
            firstCol, lastCol, gradeCol, sectionCol,
            branchCol, admissionCol, usernameCol, passwordCol
          ].includes(-1)
        ) {
          continue;
        }

        for (let i = headerRowIdx + 1; i < sheetData.length; i++) {
          const rowFirst = (sheetData[i][firstCol] || "").toString().trim().toLowerCase();
          const rowLast = (sheetData[i][lastCol] || "").toString().trim().toLowerCase();
          const rowGrade = (sheetData[i][gradeCol] || "").toString().trim().toLowerCase();
          const rowSection = (sheetData[i][sectionCol] || "").toString().trim().toLowerCase();
          const rowBranch = normalizeBranchName(sheetData[i][branchCol] || "");
          const rowAdmission = (sheetData[i][admissionCol] || "").toString().trim().toLowerCase();

          if (
            rowFirst === firstName &&
            rowLast === lastName &&
            rowGrade === grade &&
            rowSection === section &&
            rowBranch === normalizeBranchName(rawBranch) &&
            rowAdmission === admissionNumber
          ) {
            const rowNum = i + 1;

            sheet.getRange(rowNum, usernameCol + 1).setValue(username);
            sheet.getRange(rowNum, passwordCol + 1).setValue(password);

            Logger.log(`✅ Updated ${firstName} ${lastName} in "${sheetName}"`);
            userUpdated = true;
            break;
          }
        }
      }
    }

    if (!userUpdated) {
      Logger.log(`❌ No match found for ${firstName} ${lastName}`);
    }
  }

  Logger.log("✅ Execution complete.");
}


