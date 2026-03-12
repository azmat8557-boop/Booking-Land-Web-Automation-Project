*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    OperatingSystem
Library    BookingProjectFunctions.py

*** Variables ***
${URL}                 https://botsdna.com/vitrualplots/
${DOWNLOAD_FOLDER}     C:\\Users\\DELL XPS\\OneDrive\\Desktop\\Booking Land Virtual\\Download_run_time
${EXCEL_FILE}          ${DOWNLOAD_FOLDER}\\input.xlsx
${SCREENSHOT_PATH}     ${DOWNLOAD_FOLDER}\\screenshot.png

*** Test Cases ***
Download Excel And Fill Form With Tables
    # ensure the download folder exists
    ${folder_exists}=    Run Keyword And Return Status    Directory Should Exist    ${DOWNLOAD_FOLDER}
    Run Keyword If    not ${folder_exists}    Create Directory    ${DOWNLOAD_FOLDER}

    # configure Chrome for automatic download
    ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    ${prefs}=             Evaluate    {"download.default_directory": r"${DOWNLOAD_FOLDER}"}
    Call Method           ${chrome_options}    add_experimental_option    prefs    ${prefs}

    Open Browser    ${URL}    chrome    options=${chrome_options}
    Click Element    xpath=//a[@href="input.xlsx"]
    Sleep    5s

    # read spreadsheet via Python keyword
    ${rows}=    Read Excel    ${EXCEL_FILE}

    FOR    ${idx}    ${row}    IN ENUMERATE    @{rows}
        ${rownum}=    Evaluate    ${idx}+1
        Log    ===== processing row ${rownum} =====

        # navigate back to the booking page every iteration
        Go To    ${URL}
        Wait Until Element Is Visible    xpath=//a[@href="input.xlsx"]    10s

        ${BuyerMobile}=    Set Variable    ${row['Buyer Mobile']}
        ${SellerMobile}=   Set Variable    ${row['Seller Mobile']}
        ${Plot_No}=        Set Variable    ${row['Plot No']}
        ${Sqft}=           Set Variable    ${row['Sqft']}

        ${Buyer_No}=       Digits Only    ${BuyerMobile}
        ${Seller_No}=      Digits Only    ${SellerMobile}

        Run Keyword And Ignore Error    Click Element    xpath=//tr[td[contains(normalize-space(.),'${Buyer_No}')]]//input[@name='Buyer']
        Run Keyword And Ignore Error    Click Element    xpath=//tr[td[contains(normalize-space(.),'${Seller_No}')]]//input[@name='seller']

        Wait Until Element Is Visible    xpath=//td[contains(normalize-space(.),'Plot No')]/following-sibling::td//input    10s
        Input Text    xpath=//td[contains(normalize-space(.),'Plot No')]/following-sibling::td//input    ${Plot_No}

        Wait Until Element Is Visible    xpath=//td[contains(normalize-space(.),'Sqft')]/following-sibling::td//input    10s
        Input Text    xpath=//td[contains(normalize-space(.),'Sqft')]/following-sibling::td//input    ${Sqft}

        Click Button    xpath=//table[not(contains(@border,"2"))]//input[@type='button']
        Wait Until Element Is Visible    id=TransNo    10s
        ${Trans_No}=    Get Text    id=TransNo
        Set To Dictionary    ${row}    Transaction Number    ${Trans_No}
    END

    # write the results back to disk
    Write Excel    ${EXCEL_FILE}    ${rows}

    Capture Page Screenshot    ${SCREENSHOT_PATH}
    Close Browser
