#cd C:\Users\1qkrc\Desktop\RSelenium
#java -Dwebdriver.gecko.driver="geckodriver.exe" -jar selenium-server-standalone-3.141.59.jar -port 4445


#--------------- function modify ----------------#
Click <- function(xpath){
  Select=remDr$findElement(using="xpath",value=xpath)
  Select$clickElement()
}
InputText <- function(string,xpath,enter=FALSE){
  input <- remDr$findElement(using="xpath", value=xpath)
  if(enter){
    input$sendKeysToElement(list(string,key="enter"))
  }else{
    input$sendKeysToElement(list(string))
  }
}

#-------------------- 크롬에서 원하는 사이트 열기 ----------------------#
SiteOpen <- function(site="https://google.co.kr",BS_Open=TRUE){
  if(BS_Open){ # 브라우저를 키고 사이트를 들어갈껀지 결정
    library(XML)
    library(dplyr)
    library(stringr)
    library(RSelenium)
    remDr <- remoteDriver(remoteServerAddr = 'localhost', 
                          port = 4445L, # 포트번호 입력 
                          browserName = "chrome") 
    remDr$open()
    Sys.sleep(2)
  }
  remDr$navigate(site)
  return (remDr)
}

#-------------- 아이템매니아 사이트 로그인 ---------------#
ItemLogin <- function(ID,Password){
  InputText(ID,'//input[@id="user_id"]')
  InputText(Password,'//input[@id="user_password"]',enter=TRUE)
}

#------------ 팝업창 제거 ------------#
Exitpopup <- function(){
  tryCatch(Click('//area[@title="닫기"]'),
           error = function(e) print("팝업창이 없거나 변경되었습니다."),
           warning = function(w) print("팝업창이 없거나 변경되었습니다."),
           finally = NULL)
}

#-------------- "크레이지 아케이드"(게임) 에서 "파편"(아이템) 검색 ------------#
Retrival <- function(item){
  remDr$setWindowSize(1200,800) # 윈도우 사이즈 설정 (뒤에 클릭에서 문제가 생김)
  remDr$setWindowPosition(0,0)
  #------------- 게임-서버 선택 -----------#
  InputText("크레이지아케이드",'//input[@class="g_text"]')
  Click('//*[@id="g_gameServer"]/div[1]/ul/li[2]/span')#게임명
  Click('//*[@id="g_gameServer"]/div[2]/ul/li[3]')#서버
  
  #---------- 분류(아이템) 선택 후 "파편" 검색 ----------#
  Exitpopup() # 팝업닫기 <- 아이템 클릭이 안됨.
  Click('//div[@value="item"]')
  InputText(item,'//*[@id="word"]')
  Click('//ul[@class="search_word"]/li[2]/span')
  
  
  #---------- 모든 데이터 보기 ---------------#
  while(TRUE){
    res <- try({
      Click('//div[@class="load_more"]')
    },silent=TRUE)
    
    if(inherits(res, "try-error")){
      remDr$acceptAlert()
      break
    }
    Sys.sleep(2)
  }
  
}

#------------- 문서 데이터화 --------------#
GetText <-  function(){
  ##제목
  item = remDr$findElements(using="xpath",'//ul[@class="search_list search_list_normal"]//div[@class="col_02"]/a/div|//div[@class="col_02 active"]/a/div')
  item = sapply(item,function(x){unlist(x$getElementText())})
  
  item = gsub("팝니다.*|팜.*|팔아요.*",'팝니다',item)
  item = gsub("~|!|' '|★|\\n|◘|█|※|▷|●|♥|◆",'',item)
  
  ##가격
  price = remDr$findElements(using="xpath",'//ul[@class="search_list search_list_normal"]//div[@class="col_03"]/div/span')
  price = sapply(price,function(x){unlist(x$getElementText())})
  price = gsub(" |최소",'',price)

  ##시간
  time = remDr$findElements(using="xpath",'//ul[@class="search_list search_list_normal"]//div[@class="col_05"]')
  time = sapply(time,function(x){unlist(x$getElementText())})
  
  ##거래번호
  Serial_Num = remDr$findElements(using="xpath",'//ul[@class="search_list search_list_normal"]//div[@class="view_detail"]')
  Serial_Num = sapply(Serial_Num,function(x){unlist(x$getElementAttribute("trade-id"))})
  
  #데이터 프레임 생성
  data = data.frame("item"=item,"price"=price,"time"=time,"Serial_Num"=Serial_Num)

  return(data)
}

###############################################################
###############################################################
#--------------------------실행-------------------------------#
remDr <- SiteOpen("https://bit.ly/2vGdI16",BS_Open=TRUE) # 크롬에서 원하는 사이트 열기
ItemLogin(ID = "",Password = "") # 아이템매니아 사이트 로그인
Retrival("파편") # 아이템 파편 검색
database = GetText()




