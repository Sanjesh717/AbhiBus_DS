*** Settings ***
Documentation       Template robot main suite.

Library             RPA.Excel.Files
Library             RPA.FileSystem
Library             RPA.Tables
Library             RPA.Browser.Selenium    auto_close=${False}
Library             DateTime
Library             String
Library             Collections
Library             DateTime
Library             XML


*** Variables ***
${url}                  https://www.abhibus.com/
${config_path}          C:${/}Users${/}sanjesh.ld${/}Documents${/}Robocorp Projects${/}RGB${/}config.xml
${input_Excel_path}     C:${/}Users${/}sanjesh.ld${/}Documents${/}Robocorp Projects${/}RGB${/}Bus-Input.xlsx
${output_Excel_Path}    C:${/}Users${/}sanjesh.ld${/}Documents${/}Robocorp Projects${/}RGB${/}AbhibusOutput.xlsx


*** Tasks ***
Read Input Excel
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    TRY
        #${config}=    Parse Xml    config.xml
        ${config}=    Parse Xml    ${config_path}
        ${input excel}=    Get Element Text    ${config}[0]
        ${sheet}=    Get Element Text    ${config}[1]
        Open Workbook    ${input excel}
        Read Worksheet    ${sheet}
        ${read_input}=    Read Worksheet As Table    header= true
        open Abhibus website
        Read Excel file and input the data in website    ${current_date}    ${read_input}
        Close Browser
    EXCEPT
        Log    Unable to read the input excel
    END


*** Keywords ***
open Abhibus website
    Open Available Browser    ${url}
    Maximize Browser Window

Read Excel file and input the data in website
    [Arguments]    ${current_date}    ${read_input}
    ${count}=    Set Variable    1
    FOR    ${item}    IN    @{read_input}
        ${Input excel Value}=    Create List
        TRY
            ${from}=    Set Variable    ${item}[From]
            ${To}=    Set Variable    ${item}[To]
            ${Date}=    Set Variable    ${item}[Date]
            Append To List    ${Input excel Value}    ${from}    ${To}    ${Date}
            Log    ${Input excel Value}
            IF    "${Input_excel_Value}" == "[None, None, None]"
                ${count}=    Evaluate    ${count} + 1
                ${error_handling_nodata}=    Set Variable    No data found
                Write Exception if No value present    ${error_handling_nodata}    ${count}
            ELSE IF    "${from}" == "None"
                ${count}=    Evaluate    ${count} + 1
                ${error_handling_Source}=    Set Variable    No source value found
                Write Exception if Source value not present    ${error_handling_Source}    ${count}
            ELSE
                Log    From is: ${from}
                IF    "${To}" == "None"
                    ${count}=    Evaluate    ${count} + 1
                    ${error_handling_To}=    Set Variable    No Destination Present
                    Write Exception if Destination value not present    ${error_handling_To}    ${count}
                ELSE
                    Log    Desination is : ${To}
                    IF    "${Date}" == "None"
                        ${count}=    Evaluate    ${count} + 1
                        ${error_handling_Date}=    Set Variable    No Date Present
                        Write Exception if Date value not present    ${error_handling_Date}    ${count}
                    ELSE
                        ${formatted_date}=    Convert Date    ${Date}    result_format=%d-%m-%Y
                        Log    Date is ${formatted_date}
                        IF    '${formatteddate}' >= '${current_date}'
                            #open Abhibus website
                            Sleep    2s
                            Input Text    //*[@id="source"]    ${from}
                            Sleep    2s
                            Press Keys    //*[@id="source"]    ENTER
                            Sleep    2s
                            Input Text    //*[@id="destination"]    ${To}
                            Sleep    2s
                            Press Keys    //*[@id="destination"]    ENTER
                            Sleep    2s
                            Click Button    //*[@id="datepicker1"]
                            #Click Element    alias:30
                            Click Element    alias:Date
                            Sleep    3s
                            Input Text    datepicker1    ${formatted_date}    clear=${true}

                            Wait Until Element Is Visible
                            ...    xpath=//a[@class="btn btn-main px-5 py-2 border-right-radius"]
                            ...    20
                            ...    seconds
                            Set Focus To Element    xpath=//a[@class="btn btn-main px-5 py-2 border-right-radius"]
                            #Click Element    xpath=//a[@class="btn btn-main px-5 py-2 border-right-radius"]
                            Wait Until Keyword Succeeds
                            ...    10x
                            ...    0.2s
                            ...    Click Element
                            ...    xpath=//a[@class="btn btn-main px-5 py-2 border-right-radius"]
                            Wait Until Element Is Enabled    //*[@id="filterPos1"]/div/div[1]/div[1]/div/span[1]
                            Sleep    5s
                            ${resultPresent}=    Does Page Contain Element
                            ...    xpath=//h2[@class="TravelAgntNm ng-binding"]
                            IF    ${resultPresent} == ${True}
                                ${count}=    Evaluate    ${count} + 1
                                Click Element    xpath=//span[@class="sort-price-up"]
                                ${list}=    First element
                                ${list1}=    Second Element
                                Write result in excel    ${list}    ${list1}    ${from}    ${To}
                                Close Workbook
                                Click Element    xpath=//span[@class="sort-price-down"]
                                ${list}=    First element
                                ${list1}=    Second Element
                                Write lowest searchresult in excel    ${list}    ${list1}    ${from}    ${To}
                                Close Workbook
                                Wait Until Keyword Succeeds
                                ...    50x
                                ...    0.5s
                                ...    click element
                                ...    css:body > nav > div > div.navbar-brand.p-0 > a
                                write completed for successfully transaction    ${count}
                            ELSE
                                ${count}=    Evaluate    ${count} + 1
                                Wait Until Keyword Succeeds
                                ...    50x
                                ...    0.5s
                                ...    click element
                                ...    css:body > nav > div > div.navbar-brand.p-0 > a
                                ${no bus}=    Set Variable    No Direct bus found between source and Destination
                                Write Exception if No Bus found    ${no bus}    ${count}
                            END
                        ELSE
                            ${count}=    Evaluate    ${count} + 1
                            Log    date is passed away
                            ${date_passed}=    Set Variable    date is passed away
                            Write Exception if Date has Passed    ${date_passed}    ${count}
                        END
                    END
                END
            END
            Close Workbook
        EXCEPT
            Log    unable to enter the data
        END
    END

First element
    ${list}=    Create List
    ${bus}=    Get WebElements    xpath=//h2[@class="TravelAgntNm ng-binding"]
    ${bus_name_First_element}=    Get WebElement    ${bus}[0]
    ${bus_name}=    Get text    ${bus_name_First_element}

    ${price}=    Get WebElements    xpath=//strong[@class="TickRate ng-binding"]
    ${price_First_element}=    Get WebElement    ${price}[0]
    ${Amount}=    Get Text    ${price_First_element}

    ${strTime}=    Get WebElements    xpath=//span[@class="StrtTm tooltipsteredBoarding ng-binding tooltipstered"]
    ${strTime_First_element}=    Get WebElement    ${strTime}[0]
    ${startTime}=    Get Text    ${strTime_First_element}

    ${ArrTime}=    Get WebElements    xpath=//span[@class="ArvTm tooltipsteredDropping ng-binding tooltipstered"]
    ${ArrTime_First_element}=    Get WebElement    ${ArrTime}[0]
    ${ArrivalTime}=    Get Text    ${ArrTime_First_element}
    ${Rat}=    Get WebElements    xpath=//span[@class="rating-sec ng-binding"]
    TRY
        ${Rat_First_element}=    Get WebElement    ${Rat}[0]
        ${Rating}=    Get Text    ${Rat_First_element}
    EXCEPT    message
        ${rating}=    Set Variable    no rating
    END
    Append To List    ${list}    ${bus_name}    ${startTime}    ${ArrivalTime}    ${Rating}    ${Amount}
    RETURN    ${list}

 Second Element
    ${list1}=    Create List
    ${bus}=    Get WebElements    xpath=//h2[@class="TravelAgntNm ng-binding"]
    ${bus_name_Second_element}=    Get WebElement    ${bus}[1]
    ${bus_name}=    Get text    ${bus_name_Second_element}

    ${price}=    Get WebElements    xpath=//strong[@class="TickRate ng-binding"]
    ${price_Second_element}=    Get WebElement    ${price}[1]
    ${Amount}=    Get Text    ${price_Second_element}

    ${strTime}=    Get WebElements    xpath=//span[@class="StrtTm tooltipsteredBoarding ng-binding tooltipstered"]
    ${strTime_Second_element}=    Get WebElement    ${strTime}[1]
    ${startTime}=    Get Text    ${strTime_Second_element}

    ${ArrTime}=    Get WebElements    xpath=//span[@class="ArvTm tooltipsteredDropping ng-binding tooltipstered"]
    ${ArrTime_Second_element}=    Get WebElement    ${ArrTime}[1]
    ${ArrivalTime}=    Get Text    ${ArrTime_Second_element}

    ${Rat}=    Get WebElements    xpath=//span[@class="rating-sec ng-binding"]
    TRY
        ${Rat_Second_element}=    Get WebElement    ${Rat}[1]
        ${Rating}=    Get Text    ${Rat_Second_element}
    EXCEPT    message
        ${rating}=    Set Variable    no rating
    END

    Append To List    ${list1}    ${bus_name}    ${startTime}    ${ArrivalTime}    ${Rating}    ${Amount}
    RETURN    ${list1}

Write result in excel
    [Arguments]    ${list}    ${list1}    ${from}    ${To}
    Open Workbook    ${output_Excel_Path}
    ${sheet exist}=    Worksheet Exists    ${from}-${To} Highest price
    IF    ${sheet_exist} == False
        Create Worksheet    ${from}-${To} Highest price
        Read Worksheet    ${from}-${To} Highest price
        Set cell value    1    A    Bus name
        Set Cell Value    1    B    Starting Time
        Set Cell Value    1    C    Arrival Time
        Set Cell Value    1    D    Rating
        Set Cell Value    1    E    Price
        Set cell value    2    A    ${list}[0]
        Set Cell Value    2    B    ${list}[1]
        Set Cell Value    2    C    ${list}[2]
        Set Cell Value    2    D    ${list}[3]
        Set Cell Value    2    E    ${list}[4]
        Set cell value    3    A    ${list1}[0]
        Set Cell Value    3    B    ${list1}[1]
        Set Cell Value    3    C    ${list1}[2]
        Set Cell Value    3    D    ${list1}[3]
        Set Cell Value    3    E    ${list1}[4]
        Save Workbook
    ELSE
        Read Worksheet    ${from}-${To} Highest price    overwrite=True
        Set cell value    1    A    Bus name
        Set Cell Value    1    B    Starting Time
        Set Cell Value    1    C    Arrival Time
        Set Cell Value    1    D    Rating
        Set Cell Value    1    E    Price
        Set cell value    2    A    ${list}[0]
        Set Cell Value    2    B    ${list}[1]
        Set Cell Value    2    C    ${list}[2]
        Set Cell Value    2    D    ${list}[3]
        Set Cell Value    2    E    ${list}[4]
        Set cell value    3    A    ${list1}[0]
        Set Cell Value    3    B    ${list1}[1]
        Set Cell Value    3    C    ${list1}[2]
        Set Cell Value    3    D    ${list1}[3]
        Set Cell Value    3    E    ${list1}[4]
        Save Workbook
    END

Write lowest searchresult in excel
    [Arguments]    ${list}    ${list1}    ${from}    ${To}
    Open Workbook    ${output_Excel_Path}
    ${sheet exist}=    Worksheet Exists    ${from}-${To} Lowest price
    IF    ${sheet_exist} == False
        Create Worksheet    ${from}-${To} Lowest price
        Read Worksheet    ${from}-${To} Lowest price
        Set cell value    1    A    Bus name
        Set Cell Value    1    B    Starting Time
        Set Cell Value    1    C    Arrival Time
        Set Cell Value    1    D    Rating
        Set Cell Value    1    E    Price
        Set cell value    2    A    ${list}[0]
        Set Cell Value    2    B    ${list}[1]
        Set Cell Value    2    C    ${list}[2]
        Set Cell Value    2    D    ${list}[3]
        Set Cell Value    2    E    ${list}[4]
        Set cell value    3    A    ${list1}[0]
        Set Cell Value    3    B    ${list1}[1]
        Set Cell Value    3    C    ${list1}[2]
        Set Cell Value    3    D    ${list1}[3]
        Set Cell Value    3    E    ${list1}[4]
        Save Workbook
    ELSE
        Read Worksheet    ${from}-${To} Lowest price    overwrite=True
        Set cell value    1    A    Bus name
        Set Cell Value    1    B    Starting Time
        Set Cell Value    1    C    Arrival Time
        Set Cell Value    1    D    Rating
        Set Cell Value    1    E    Price
        Set cell value    2    A    ${list}[0]
        Set Cell Value    2    B    ${list}[1]
        Set Cell Value    2    C    ${list}[2]
        Set Cell Value    2    D    ${list}[3]
        Set Cell Value    2    E    ${list}[4]
        Set cell value    3    A    ${list1}[0]
        Set Cell Value    3    B    ${list1}[1]
        Set Cell Value    3    C    ${list1}[2]
        Set Cell Value    3    D    ${list1}[3]
        Set Cell Value    3    E    ${list1}[4]
        Save Workbook
    END

Write Exception if Source value not present
    [Arguments]    ${error_handling_Source}    ${count}
    Open Workbook    ${input_Excel_path}
    set cell value    ${count}    D    ${error_handling_Source}
    Save Workbook

Write Exception if Destination value not present
    [Arguments]    ${error_handling_To}    ${count}
    Open Workbook    ${input_Excel_path}
    set cell value    ${count}    D    ${error_handling_To}
    Save Workbook

Write Exception if Date value not present
    [Arguments]    ${error_handling_Date}    ${count}
    Open Workbook    ${input_Excel_path}
    set cell value    ${count}    D    ${error_handling_Date}
    Save Workbook

Write Exception if No value present
    [Arguments]    ${error_handling_nodata}    ${count}
    Open Workbook    ${input_Excel_path}
    set cell value    ${count}    D    ${error_handling_nodata}
    Save Workbook

Write Exception if Date has Passed
    [Arguments]    ${date_passed}    ${count}
    Open Workbook    ${input_Excel_path}
    set cell value    ${count}    D    ${date_passed}
    Save Workbook

Write Exception if No Bus found
    [Arguments]    ${no bus}    ${count}
    Open Workbook    ${input_Excel_path}
    set cell value    ${count}    D    ${no bus}
    Save Workbook

write completed for successfully transaction
    [Arguments]    ${count}
    Open Workbook    ${input_Excel_path}
    set cell value    ${count}    D    completed
    Save Workbook
