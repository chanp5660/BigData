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

#-------------------- chrome open ----------------------#
ChromeOpen <- function(){
  library(rvest)
  library(XML)
  library(dplyr)
  library(stringr)
  library(RSelenium)
  
  remDr <- remoteDriver(remoteServerAddr = 'localhost', 
                        port = 4445L, # 포트번호 입력 
                        browserName = "chrome") 
  remDr$open()
  Sys.sleep(2)
  return (remDr)
}

#-------------- 아이템매니아 사이트 로그인 ---------------#
ItemLogin <- function(ID,Password){
  remDr$navigate("http://www.itemmania.com/portal/user/p_login_form.html?returnUrl=http%3A%2F%2Fwww.itemmania.com%2Fmyroom%2F")

  InputText("snrnsk5660",'//*[@id="user_id"]')
  InputText(Password,'//*[@id=\"user_password\"]',enter=TRUE)
}

#-------------- "크레이지 아케이드"(게임) 에서 "파편"(아이템) 검색 ------------#
Retrival <- function(){
  #------------- 게임-서버 선택 -----------#
  InputText("크레이지아케이드",'//*[@id="searchGameServer"]')
  Click('//*[@id="g_gameServer"]/div[1]/ul/li[2]/span')#게임명
  Click('//*[@id="g_gameServer"]/div[2]/ul/li[3]')#서버
  
  #------------ 팝업창 제거 ------------#(제거 하는 수정 중)
  tryCatch({
      pop_up2=remDr$findElement(using="xpath",value='//*[@id="listSearchDarkWar_inptDeny"]')
      pop_up2$clickElement()
      pop_up2=remDr$findElement(using="xpath",value='//*[@id="listSearchDarkWar"]/div[1]/map/area[1]')
      pop_up2$clickElement()
    },
    error = function(e) print("팝업창이 없거나 변경되었습니다."),
    warning = function(w) print("팝업창이 없거나 변경되었습니다."),
    finally = NULL)
  
  #---------- 분류(아이템) 선택 후 "파편" 검색 ----------#
  Click('//*[@id="g_CONTENT"]/div[3]/div[4]')
  InputText("파편",'//*[@id="word"]')
  Click('//*[@id="g_CONTENT"]/div[3]/div[6]/ul/li[2]/span')#팝업에 따라 숫자가 달라짐....문제
  
  #---------- 모든 데이터 보기 ---------------#
  while(TRUE){
    res <- try({
      Click('//*[@id="g_CONTENT"]/div[10]')
    },silent=TRUE)
    
    if(inherits(res, "try-error")){
      remDr$acceptAlert()
      print("끝")
      #return()
      break
    }
    Sys.sleep(2)
  }
  
}


###############################################################
###############################################################
#--------------------------실행-------------------------------#
remDr <- ChromeOpen() # 크롬 열기
ItemLogin("","") # 아이템매니아 사이트 로그인
Retrival() # 아이템 파편 검색


