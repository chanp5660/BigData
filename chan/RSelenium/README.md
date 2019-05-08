# RSelenium_tutorial

> 설치방법 : [파일 다운로드](https://github.com/chanp5660/BigData/blob/master/chan/RSelenium/BeforeSet.zip) -> 같은 폴더에 둔다. -> cmd를 실행 -> 설치파일들이 들어있는 폴더의 디렉토리를 A라 할 때 -> *cd A* -> 작성 후 -> *java -Dwebdriver.gecko.driver="geckodriver.exe" -jar selenium-server-standalone-3.141.59.jar -port 4445* -> 실행 -> 켜둔 상태에서 진행

![rsel](https://user-images.githubusercontent.com/46266247/57371870-e58dfc00-71ce-11e9-90b3-fc977e19d1db.png)

RSelenium 기초 문법 참조 사이트(https://ropensci.org/tutorials/rselenium_tutorial/)

```r
library(RSelenium)
remDr <- remoteDriver(remoteServerAddr = "localhost"
                      , port = 4445L
                      , browserName = "chrome"
)
remDr$open() # 크롬열기
remDr$getStatus() # 상태

#--------------- Navigating using RSelenium Basic Navigation ------------------#

remDr$navigate("http://www.google.com") # 사이트 연결
remDr$navigate("http://www.bbc.co.uk") # 사이트 연결
remDr$getCurrentUrl() # 현재 URL
remDr$goBack() # 뒤로 가기
remDr$getCurrentUrl() # 현재 URL
remDr$goForward() # 앞으로 가기
remDr$getCurrentUrl() # 현재 URL
remDr$refresh() # 새로고침

#------------------ Accessing elements in the DOM(Document Object Model) -------------------------#

remDr$navigate("http://www.google.com") # 구글 열기

# id로 노드 찾기
webElem <- remDr$findElement(using = 'id', value = "gsr") # id가 gsr인 것
webElem$getElementAttribute("id") # "gsr"
webElem$getElementAttribute("class") # "hp vasq"

# class 이름으로 노드 찾기
webElem <- remDr$findElement(using = 'class name', value = "hp") # class name이 hp관련된 것.
webElem$getElementAttribute("class") # "hp vasq"
webElem$getElementAttribute("type") # list()

# css-selectors 사용해서 노드 찾기
webElem <- remDr$findElement(using = 'css selector', "input.gLFyf") # 입력창 input tag의 gLFyf 클래스 설정 
webElem <- remDr$findElement(using = 'css selector', "input#gLFyf")

# 이름으로 노드 찾기 
webElem <- remDr$findElement(using = 'name', "q") # name이 q인 노드 찾기
webElem$getElementAttribute("name") # "gLFyf gsfi"
webElem$getElementAttribute("id") # ""

# xpath 사용해서 노드 찾기 
webElem <- remDr$findElement(using = 'xpath', "//*/body[@id = 'gsr']")  # tag가 "body"이고 id가 "gsr"인 노드
webElem <- remDr$findElement(using = 'xpath', "//*/body[@class = 'hp vasq']") # tag가 "body"이고 class가 "hp vasq"인 노드 

# -----------------------Sending events to elements----------------------#
# 문자 작성
remDr$navigate("http://www.google.com/ncr")
webElem <- remDr$findElement(using = "xpath", '//input[@class="gLFyf gsfi"]')
webElem$sendKeysToElement(list("R Cran"))

# 키 실행 version_1
remDr$navigate("http://www.google.com/ncr")
webElem <- remDr$findElement(using = "xpath", '//input[@class="gLFyf gsfi"]')
webElem$sendKeysToElement(list("R Cran","\uE007"))

# 키 실행 version_2
remDr$navigate("http://www.google.com/ncr")
webElem <- remDr$findElement(using = "xpath", '//input[@class="gLFyf gsfi"]')
webElem$sendKeysToElement(list("R Cran", key = "enter"))

# 마우스 실행 
remDr$navigate("http://www.google.com/ncr")
webElem <- remDr$findElement(using = "xpath", '//input[@class="gLFyf gsfi"]')
webElem$sendKeysToElement(list("R Cran"))
webElem <- remDr$findElement(using = "xpath", '//div[@class="sbl1"]')
webElem$clickElement()
```
