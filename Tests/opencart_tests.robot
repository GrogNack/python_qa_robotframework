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
@{TEST_PRODUCT}    test_good    test_good_tag    test_good_model

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
    ${OLD}    Get Number Of Goods
    ${OLD}    Evaluate    ${OLD} + 1
    Click Element    css=a[data-original-title="Add New"]
    Input Text    css=#input-name1    ${TEST_PRODUCT}[0]
    Input Text    css=#input-meta-title1    ${TEST_PRODUCT}[1]
    Click Element    css=[href="#tab-data"]
    Input Text    css=[name="model"]    ${TEST_PRODUCT}[2]
    Click Element    css=.fa-save
    ${NEW}    Get Number Of Goods
    Should Be Equal As Integers    ${NEW}    ${OLD}

Test delete goods
    Go To    ${ADMIN_URL}
    Authorization    ${LOGIN}    ${PWD}
    Move To Catalog
    Filter    ${TEST_PRODUCT}[0]
    ${OLD}    Get Number Of Goods
    ${OLD}    Evaluate    ${OLD} - 1
    Click Element    css=tr:nth-child(2)>td>input[type="checkbox"]
    Click Element    css=[data-original-title="Delete"]
    Handle Alert
    ${NEW}    Get Number Of Goods
    Should Be Equal As Integers    ${NEW}    ${OLD}

Test filter list of products
    Go To    ${ADMIN_URL}
    Authorization    ${LOGIN}    ${PWD}
    Move To Catalog
    Filter    ${PRODUCT_NAME}
    ${GOODS_COUNT}    Get Text    css=div.row>div.text-right
    ${COUNT}    Get Number Of Goods
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

Get Number Of Goods
    ${GOODS_COUNT}    Get Text    css=div.row>div.text-right
    @{INFO_STRING_BEFORE} =    Split String    ${GOODS_COUNT}    ${SPACE}
    ${COUNT}    Convert To Integer    ${INFO_STRING_BEFORE}[5]
    [Return]    ${COUNT}

Filter    [Arguments]    ${NAME}
    Input Text    css=[name="filter_name"]    ${NAME}
    Click Button    css=#button-filter
