I designed this program to automate credential generation along with course and group allocation, as well as authentication type assignment. This process was extremely complex because each institute follows different standards for usernames and passwords. Additionally, every institute offers 10–15 courses and 40–50 groups, making manual selection both time-consuming and error-prone for my team.

To solve this, I built a system that intelligently assigns the correct course and group based on the information provided in the input data.

One of the major challenges was handling messy and inconsistent data from customers in the Course and Group columns. There were frequent typos, and different institutes used different terms for the same concept. For example, “Class 3” could appear as:

Class3
NNLP 3
NNLP - III
Junior Prep
Pre Prep
III

These variations, along with spelling mistakes and inconsistent naming, made standardization difficult.

Solution Approach
Designed a database to store courses, groups, and related mappings
Built a Python pipeline to extract raw data from a Google Sheets tracker (used by customers)
Processed and stored the data into the database
Applied data cleaning, transformation, and mapping logic to standardize courses and groups
Generated a final structured CSV file
Automatically saved the CSV to a Google Drive folder using Python

The final output CSV can be directly uploaded to the LMS, eliminating manual effort and significantly reducing errors.
