*** Settings ***
Library    SeleniumLibrary
Library    String
Library    Dialogs

Suite Setup    Open Browser    browser=chrome    options=add_argument("--start-maximized")
Suite Teardown    Close Browser

*** Variables ***
${BASE_URL}    http://localhost
${ADMIN_URL}    ${BASE_URL}/admin/
${LOGIN}    user
${PWD}    bitnami
${PRODUCT_NAME}    Product 8


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
    Move To Catalog
    ${GOODS_COUNT}    Get Text    css=div.row>div.text-right
    @{INFO_STRING_BEFORE} =    Split String    ${GOODS_COUNT}    ${SPACE}
    ${OLD}    Convert To Integer    ${INFO_STRING_BEFORE}[5]
    ${OLD}    Evaluate    ${OLD} + 1
    Click Element    css=a[data-original-title="Add New"]
    Input Text    css=#input-name1    test_good
    Input Text    css=#input-meta-title1    test_good_tag
    Click Element    css=[href="#tab-data"]
    Input Text    css=[name="model"]    test_good_model
    Click Element    css=.fa-save
    ${GOODS_COUNT}    Get Text    css=div.row>div.text-right
    @{INFO_STRING_AFTER} =    Split String    ${GOODS_COUNT}    ${SPACE}
    ${NEW}    Convert To Integer    ${INFO_STRING_AFTER}[5]
    Should Be Equal As Integers    ${NEW}    ${OLD}

Test delete goods
    Go To    ${ADMIN_URL}
    Authorization    ${LOGIN}    ${PWD}
    Move To Catalog
    Input Text    css=[name="filter_name"]    test_good
    Click Button    css=#button-filter
    ${GOODS_COUNT}    Get Text    css=div.row>div.text-right
    @{INFO_STRING_BEFORE} =    Split String    ${GOODS_COUNT}    ${SPACE}
    ${OLD}    Convert To Integer    ${INFO_STRING_BEFORE}[5]
    ${OLD}    Evaluate    ${OLD} - 1
    Click Element    css=tr:nth-child(2)>td>input[type="checkbox"]
    Click Element    css=[data-original-title="Delete"]
    Handle Alert
    ${GOODS_COUNT}    Get Text    css=div.row>div.text-right
    @{INFO_STRING_BEFORE} =    Split String    ${GOODS_COUNT}    ${SPACE}
    ${NEW}    Convert To Integer    ${INFO_STRING_BEFORE}[5]
    Should Be Equal As Integers    ${NEW}    ${OLD}

Test filter list of products
    Go To    ${ADMIN_URL}
    Authorization    ${LOGIN}    ${PWD}
    Move To Catalog
    Input Text    css=[name="filter_name"]    ${PRODUCT_NAME}
    Click Button    css=#button-filter
    ${GOODS_COUNT}    Get Text    css=div.row>div.text-right
    @{INFO_STRING} =    Split String    ${GOODS_COUNT}    ${SPACE}
    ${COUNT}    Convert To Integer    ${INFO_STRING}[5]
    should be equal as integers    ${COUNT}    1


*** Keywords ***
Verify Page Title    [Arguments]    ${VALUE}
    ${TITLE}    Get Title
    Should Contain    ${TITLE}    ${VALUE}

Authorization    [Arguments]    ${USR_NAME}    ${USR_PWD}
    Input Text    css=#input-username    ${USR_NAME}
    Input Text    css=#input-password    ${USR_PWD}
    Click Button    css=button[type="submit"]

Move To Catalog
    Click Element    css=#menu-catalog
    Sleep    30ms
    Click Element    css=#menu-catalog>ul>li:nth-child(2)
