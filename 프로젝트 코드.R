cd C:\Users\meuch\OneDrive\문서\BigData\sele

java -Dwebdriver.gecko.driver="geckodriver.exe" -jar selenium-server-standalone-3.141.59.jar -port 4445


library(dplyr)
library(stringr)
library(RSelenium)
####################
remDr <- remoteDriver(remoteServerAddr = 'localhost', 
                      port = 4445L, # 포트번호 입력 
                      browserName = "chrome") 
remDr$open() 
remDr$navigate("http://www.itemmania.com/portal/user/p_login_form.html?returnUrl=http%3A%2F%2Fwww.itemmania.com%2Fmyroom%2F")


id <- remDr$findElement(using="xpath", value='//*[@id="user_id"]') 
pw <- remDr$findElement(using="xpath", value='//*[@id=\"user_password\"]') 

id$sendKeysToElement(list("meucham1")) 
pw$sendKeysToElement(list("zbqmWkd11!@#")) 

# 로그인 버튼 클릭 
login_btn=remDr$findElement(using="xpath",value='//*[@id="login_before"]/div[1]/img')
login_btn$clickElement()  #로그인 성공 후 마이룸으로

#팝니다 원하는 게임, 서버 접속
game_box <- remDr$findElement(using="xpath", value='//*[@id="searchGameServer"]')
game_box$sendKeysToElement(list("크레이지아케이드")) 
game_select=remDr$findElement(using="xpath",value='//*[@id="g_gameServer"]/div[1]/ul/li[2]/span')
game_select$clickElement()
server_select=remDr$findElement(using="xpath",value='//*[@id="g_gameServer"]/div[2]/ul/li[3]')
server_select$clickElement()


#팝업창 지우기
pop_up2=remDr$findElement(using="xpath",value='//*[@id="listSearchDjb_inptDeny"]')
pop_up2$clickElement()
pop_up2=remDr$findElement(using="xpath",value='//*[@id="listSearchDjb"]/div[1]/map/area[1]')
pop_up2$clickElement()



#아이템 클릭
#아이템류 선택 후 아이템 검색
server_select=remDr$findElement(using="xpath",value='//*[@id="g_CONTENT"]/div[2]/div[4]')
server_select$clickElement()
##아이템명 입력 후 검색
item <- remDr$findElement(using="xpath", value='//*[@id="word"]') 
item$sendKeysToElement(list("파편")) 
item_search=remDr$findElement(using="xpath",value='//*[@id="word"]')
item_search$clickElement()
item_search=remDr$findElement(using="xpath",value='//*[@id="g_CONTENT"]/div[2]/div[6]/ul/li[2]/span')
item_search$clickElement()


##50줄 더보기 클릭
item_more=remDr$findElement(using="xpath",value='//*[@id="g_CONTENT"]/div[10]')
item_more$clickElement()


#물품전체 긁어오기
html = remDr$getPageSource()[[1]]
html = read_html(html)


#전체에서
normal=html_nodes(html,'#g_CONTENT > ul.search_list.search_list_normal > li') %>% html_text()
##제목
{ 
  item = gsub(" ",'',normal)
  item = gsub("\t\t\t\t\t.*",'',item)
  item = gsub("\t\t\t\t",'',item)
  item = gsub("팝니다.*",'팝니다',item)
  item = gsub("팜.*",'팜',item)
  item = gsub("팔아요.*",'팔아요',item)
  item = gsub("█|※|▷|●|♥|◆",'',item)
}


##가격
{
  price = gsub(" ",'',normal)
  price = gsub(".*\t\t\t\t\t",'',price)
  price = gsub("최소.*",'',price)
  price = gsub("원.*","원",price)
  price = gsub("1개당","",price)
}

#데이터 프레임 생성
data = data.frame(item=item,price=price)
data

setwd("D:\\빅데이터\\빅데이터")
write.csv(data,"data.csv")
##
