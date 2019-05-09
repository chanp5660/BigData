# 실제 코드 

[RSelenium_tutorial](https://github.com/chanp5660/BigData/tree/master/chan/RSelenium)

[R코드 다운로드](https://github.com/chanp5660/chanp5660/files/3150876/Itemmania.txt)

## 함수구현
```r
#cd C:\Users\1qkrc\Desktop\RSelenium
#java -Dwebdriver.gecko.driver="geckodriver.exe" -jar selenium-server-standalone-3.141.59.jar -port 4445

#setwd("T:/2019-1/bigdataanalysis/team") # 초기위치 설정

#--------------- function modify ----------------#
Click <- function(xpath){
  Select=remDr$findElement(using="xpath",value=xpath)
  Select$clickElement()
}
InputText <- function(string,xpath,enter=FALSE){
  input <- remDr$findElement(using="xpath", value=xpath)
  input$clearElement()# 원래 있던 내용 지우기
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
    remDr$setWindowSize(1200,800) # 윈도우 사이즈 설정 (뒤에 클릭에서 문제가 생김)
    remDr$setWindowPosition(0,0)
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

#------------- 게임-서버 선택 -----------#
GameServer <- function(Gamename,Server){
  Sys.sleep(1)
  InputText(Gamename,'//input[@class="g_text"]')
  
  #게임명 클릭
  select <- remDr$findElements(using="xpath",'//div[@class="game"]/ul')
  t = sapply(select,function(x){unlist(x$getElementText())})
  name_ps=match(Gamename,strsplit(t,"\\n")[[1]])[[1]]
  if(is.na(name_ps)){
    print(paste0("'",Gamename,"' 게임명은 없습니다."))
    return(-1) # 에러 발생 
  }
  
  Click(paste0('//div[@class="game"]/ul/li[',name_ps,']/span'))
  
  
  #서버명 클릭
  select <- remDr$findElements(using="xpath",'//div[@class="server server_t"]/ul')
  t = sapply(select,function(x){unlist(x$getElementText())})
  name_ps=match(Server,strsplit(t,"\\n")[[1]])[[1]]
  if(is.na(name_ps)){
    print(paste0("'",Server,"' 서버명은 없습니다."))
    return(-1) # 에러 발생 
  }
  Click(paste0('//div[@class="server server_t"]/ul/li[',name_ps,']'))
  
  return(1) #무사히 끝남
}

#-------------- 아이템 검색 ------------#
Retrival <- function(item=NA){
  Sys.sleep(2)
  #---------- 분류(아이템) 선택 후 "파편" 검색 ----------#
  Exitpopup() # 팝업닫기 <- 아이템 클릭이 안됨.
  Sys.sleep(2)
  Click('//div[@value="item"]')
  
  if(!is.na(item)){ # 아이템을 적지 않았을때는 그냥 그 창에서 실행 
    InputText(item,'//*[@id="word"]')
    Click('//ul[@class="search_word"]/li[2]/span')
  }
  
  
  #---------- 모든 데이터 보기 ---------------#
  n=1
  while(n<9){
    res <- try({
      Click('//div[@class="load_more"]')
    },silent=TRUE)
    
    if(inherits(res, "try-error")){
      remDr$acceptAlert()
      break
    }
    Sys.sleep(2)
    n=n+1
  }
  
}

#------------- 문서 데이터화 --------------#
GetText <-  function(){
  ##제목
  item = remDr$findElements(using="xpath",'//ul[@class="search_list search_list_normal"]//div[@class="col_02"]/a/div|//ul[@class="search_list search_list_normal"]//div[@class="col_02 active"]/a/div')
  item = sapply(item,function(x){unlist(x$getElementText())})
  
  item = gsub("팝니다.*|팜.*|팔아요.*",'팝니다',item)
  item = gsub("=|〓|　|▩|◁|◀|■|◈|━|~|!| |★|\\n|◘|█|※|▶|▷|●|♥|◆",'',item)

  # 추가적으로 <>안에 있는 묶은 제거 특수문자
  
  
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
  
  ##날짜
  Date = substr(Serial_Num,1,8)
  
  #데이터 프레임 생성
  data = data.frame("item"=item,"price"=price,"Serial_Num"=Serial_Num,"Date"=Date,"time"=time)
  
  return(data)
}

#------------- 게임명-서버명-아이템명 ---------------#
Database <- function(Gamename,Server,itemname){
  # 게임명 만큼 반복
  Sys.sleep(1)
  g_list = list()
  e=1 # 에러확인 
  for(g in 1:length(Gamename)){
    # 서버명 만큼 반복
    s_list = list()
    for(s in 1:length(Server)){
      e = GameServer(Gamename[g],Server[s])
      if(e<1){# 에러 발견 
        print("#--------------------입력오류----------------#")
        next}
      # 아이템명 만큼 반복
      item_list = list()
      for(i in 1:length(itemname)){
        try(Retrival(itemname[i]),silent=T)
        item_list[[i]]=GetText()
        names(item_list)[length(item_list)]=itemname[i]
      }
      s_list[[s]] = item_list
      names(s_list)[length(s_list)]=Server[s]
    }
    g_list[[g]]=s_list
    names(g_list)[length(g_list)]=Gamename[g]
  }
  return(g_list)
}

#------------- 데이터 저장 ---------------#
SaveData <- function(Data,Path){
  # 저장 데이터 Data 
  # 저장 디렉토리 Path 
  t = list.files(path=Path, pattern = ".csv")
  if(length(t)==0){
    write.csv(Data,paste0(Path,"test1.csv"),row.names = F)
  }else{
    t = max(as.numeric(gsub("test|.csv","",t)))+1
    write.csv(Data,paste0(Path,"test",t,".csv"),row.names = F)
  }
}



```
## 예시 실행
(게임명-서버-아이템명)
크레이지아케이드-happy-아이템12가지 [item.txt](https://github.com/chanp5660/chanp5660/files/3150864/item.txt)
```r
### 크롬에서 원하는 사이트 열기
Itemmania_url = "https://bit.ly/2vGdI16"
remDr <- SiteOpen(Itemmania_url,BS_Open=TRUE) 

### 아이템매니아 사이트 로그인
ID = ""
Password = ""
ItemLogin(ID,Password)

### 아이템 정보 
item = as.vector(unlist(read.csv("item.txt",header=F)))

### 게임명-서버명-아이템명 데이터화
Gamename = "크레이지아케이드"
Severname = "happy"
itemname = item
database = Database(Gamename,Servername,itemname)

### 게임명-서버명-아이템명 데이터화 (첫화면에서 실행해보기.)
database = Database("로스트아크","루페온",item=NA)

### 스케줄링
Path = "T:/2019-1/bigdataanalysis/team/result/"
Data = Database("크레이지아케이드","happy",item=NA)
SaveData(Data[[1]][[1]][[1]],Path)

```
결과 예시 [한번 실행 결과 보기](https://github.com/chanp5660/BigData/blob/master/chan/test.csv) , [4시간씩 5번 결과](https://github.com/meucham11/BigData/blob/master/5hours.csv)

![결과](https://user-images.githubusercontent.com/46266247/57372367-66012c80-71d0-11e9-9fbd-8c966f5e1078.png)
