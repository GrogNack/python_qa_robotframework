*** Settings ***
Library    SeleniumLibrary
Library    String

Suite Setup    Open Browser    browser=chrome    options=add_argument("--start-maximized")
Suite Teardown    Close Browser

*** Variables ***
${BASE_URL}    http://localhost
${ADMIN_URL}    ${BASE_URL}/admin/
${LOGIN}    user
${PWD}    bitnami


*** Test Cases ***
Check main page
    Go To    ${BASE_URL}
    Verify Page Title    Your Store
    Element Text Should Be    css=a[href="http://www.opencart.com"]    OpenCart
    Element Should Be Visible    css=div.swiper-viewport>div#slideshow0
    Element Should Be Visible    css=div#logo
    Element Should Be Visible    css=input[name="search"]
    Element Should Be Visible    css=h3
    Element Should Be Visible    css=div.row>div[class^=product-layout]

Test authirization for administrator
    Go To    ${ADMIN_URL}
    Authorization    ${LOGIN}    ${PWD}
    Element Should Be Visible    css=#user-profile
    Element Text Should Be    css=li.dropdown>a.dropdown-toggle    John Doe

Test add goods
    Go To    ${ADMIN_URL}
    Authorization    ${LOGIN}    ${PWD}
    Click Element    css=#menu-catalog
    Click Element    css=#menu-catalog>ul>li:nth-child(2)
    ${GOODS_COUNT}    Get Text    css=div.row>div.text-right
    @{INFO_STRING_BEFORE} =    Split String    ${GOODS_COUNT}    ${SPACE}
    ${OLD}    @{INFO_STRING_BEFORE}[4]
    Click Button    css=[data-original-title="Add New"]
    Input Text    css=#input-name1    test_good
    Input Text    css=#input-meta-title1    test_good_tag
    Click Button    css=[href="#tab-data"]
    Input Text    css=[name="model"]    test_good_model
    Click Button    css=.fa-save
    ${GOODS_COUNT}    Get Text    css=div.row>div.text-right
    @{INFO_STRING_AFTER} =    Split String    ${GOODS_COUNT}    ${SPACE}
    @{NEW}    @{INFO_STRING_BEFORE}[5]
    ${OLD}    Evaluate    ${NEW}+1


*** Keywords ***
Verify Page Title    [Arguments]    ${VALUE}
    ${TITLE}    Get Title
    Should Contain    ${TITLE}    ${VALUE}

Authorization    [Arguments]    ${USR_NAME}    ${USR_PWD}
    Input Text    css=#input-username    ${USR_NAME}
    Input Text    css=#input-password    ${USR_PWD}
    Click Button    css=button[type="submit"]
