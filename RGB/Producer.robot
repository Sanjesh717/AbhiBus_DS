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
Library             abhibus.py
Library             XML


*** Variables ***
${url}          https://www.abhibus.com/
@{header}       Start time    Arrival time    Travel agency name    Price    Rating


*** Tasks ***
Read Input Excel
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    TRY
        ${config}=    Parse Xml    config.xml
        ${input excel}=    Get Element Text    ${config}[0]
        ${sheet}=    Get Element Text    ${config}[1]
        Open Workbook    ${input excel}
        Read Worksheet    ${sheet}
        ${read_input}=    Read Worksheet As Table    header= true
        ${configlist}=    Read Excel file and input the data in website    ${current_date}    ${read_input}
    EXCEPT
        Log    Unable to read the input excel
    END


*** Keywords ***
open Abhibus website
    Open Available Browser    ${url}
    Maximize Browser Window

Read Excel file and input the data in website
    [Arguments]    ${current_date}    ${read_input}
    FOR    ${item}    IN    @{read_input}
        TRY
            ${from}=    Set Variable    ${item}[From]
            ${To}=    Set Variable    ${item}[To]
            ${Date}=    Set Variable    ${item}[Date]
            ${formatted_date}=    Convert Date    ${Date}    result_format=%d-%m-%Y
            IF    '${formatteddate}' >= '${current_date}'
                open Abhibus website
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
                Sleep    10s
                Click Element    xpath=//span[@class="sort-price-up"]
                ${listsheet}=    Sheet name
                ${sheet}=    Set Variable    ${listsheet}[0]
                ${list}=    First element
                ${list1}=    Second Element
                Write result in excel    ${list}    ${list1}    ${sheet}
                Save Workbook
                Click Element    xpath=//span[@class="sort-price-down"]
                ${listsheet}=    Sheet name
                ${sheet}=    Set Variable    ${listsheet}[1]
                ${list}=    First element
                ${list1}=    Second Element
                Write result in excel    ${list}    ${list1}    ${sheet}
                CONTINUE
            ELSE
                Log    date is passed away
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
    ${Rat_First_element}=    Get WebElement    ${Rat}[0]
    ${Rating}=    Get Text    ${Rat_First_element}
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
    ${Rat_Second_element}=    Get WebElement    ${Rat}[1]
    ${Rating}=    Get Text    ${Rat_Second_element}
    Append To List    ${list1}    ${bus_name}    ${startTime}    ${ArrivalTime}    ${Rating}    ${Amount}
    RETURN    ${list1}
#Third Element
    #${bus}=    Get WebElements    xpath=//h2[@class="TravelAgntNm ng-binding"]
    #${bus_name_Third_element}=    Get WebElement    ${bus}[2]
    #${bus_name}=    Get text    ${bus_name_Third_element}

    #${price}=    Get WebElements    xpath=//strong[@class="TickRate ng-binding"]
    #${bus_name_Third_element}=    Get WebElement    ${price}[2]
    #${Amount}=    Get Text    ${bus_name_Third_element}

    #${strTime}=    Get WebElements    xpath=//span[@class="StrtTm tooltipsteredBoarding ng-binding tooltipstered"]
    #${bus_name_Third_element}=    Get WebElement    ${strTime}[2]
    #${startTime}=    Get Text    ${bus_name_Third_element}

    #${ArrTime}=    Get WebElements    xpath=//span[@class="ArvTm tooltipsteredDropping ng-binding tooltipstered"]
    #${bus_name_Third_element}=    Get WebElement    ${ArrTime}[2]
    #${ArrivalTime}=    Get Text    ${bus_name_Third_element}

    #${Rat}=    Get WebElements    xpath=//span[@class="rating-sec ng-binding"]
    #${bus_name_Third_element}=    Get WebElement    ${Rat}[2]
    #${Rating}=    Get Text    ${bus_name_Third_element}

Write result in excel
    [Arguments]    ${list}    ${list1}    ${sheet}
    Open Workbook    AbhibusOutput.xlsx
    Read Worksheet    ${sheet}
    Log    ${sheet}
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
    Log    ${list1}[4]
    Save Workbook

Sheet name
    ${listsheet}=    Create List
    ${sheet1}=    Set Variable    Highest Price
    ${sheet2}=    Set Variable    Lowest Price
    Append To List    ${listsheet}    ${sheet1}    ${sheet2}
    RETURN    ${listsheet}
