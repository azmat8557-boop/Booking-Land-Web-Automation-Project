# Booking-Land-Web-Automation-Project
A  Robot‑Framework / Python project that automates the “booking” form on [https://botsdna.com/vitrualplots/]
Given an Excel file with buyer/seller mobile numbers, plot number and
square‑footage, the project :

1. launches Chrome with a customised download directory,  
2. Downloads the `input.xlsx` file from the website,  
3. Reads the spreadsheet and strips stray spaces from the headers,  
4. Iterates over every row, returning to the booking page before each pass,  
5. Selects the appropriate buyer/seller radio button (if present),  
6. Fills the plot and sqft fields and submits the form,  
7. Captures the resulting transaction number and writes it back to the Excel
   file which we downloaded.  
8. and finally saves a screenshot for troubleshooting.
9. The Robot test imports BookingTestFunctions.py as a library and calls its methods (e.g. Read Excel, Digits Only, Write Excel) to handle all of the spreadsheet‑related logic.

The business‑logic that deals with the spreadsheet is implemented in a small
Python library so that the Robot test remains clean and avoids all of the
common quoting/`Evaluate` pitfalls.
