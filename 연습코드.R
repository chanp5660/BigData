#library(rvest)
#library(XML)
library(dplyr)
library(stringr)
library(RSelenium)
####################
remDr <- remoteDriver(remoteServerAddr = 'localhost', 
                      port = 4445L, # ??Ʈ??ȣ ?Է? 
                      browserName = "chrome") 
remDr$open() 
remDr$navigate("http://www.itemmania.com/portal/user/p_login_form.html?returnUrl=http%3A%2F%2Fwww.itemmania.com%2Fmyroom%2F")


id <- remDr$findElement(using="xpath", value='//*[@id="user_id"]') 
pw <- remDr$findElement(using="xpath", value='//*[@id=\"user_password\"]') 

id$sendKeysToElement(list("")) 
pw$sendKeysToElement(list("")) 

# ?α??? ??ư Ŭ?? 
login_btn=remDr$findElement(using="xpath",value='//*[@id="login_before"]/div[1]/img')
login_btn$clickElement()  #?α??? ???? ?? ???̷?��??

#?˴ϴ? ???ϴ? ????, ???? ��??
game_box <- remDr$findElement(using="xpath", value='//*[@id="searchGameServer"]')
game_box$sendKeysToElement(list("ũ???????????̵?")) 
game_select=remDr$findElement(using="xpath",value='//*[@id="g_gameServer"]/div[1]/ul/li[2]/span')
game_select$clickElement()
server_select=remDr$findElement(using="xpath",value='//*[@id="g_gameServer"]/div[2]/ul/li[3]')
server_select$clickElement()


#?˾?â ??????
pop_up2=remDr$findElement(using="xpath",value='//*[@id="listSearchDjb_inptDeny"]')
pop_up2$clickElement()
pop_up2=remDr$findElement(using="xpath",value='//*[@id="listSearchDjb"]/div[1]/map/area[1]')
pop_up2$clickElement()



#?????? Ŭ??
#?????۷? ???? ?? ?????? ?˻?
server_select=remDr$findElement(using="xpath",value='//*[@id="g_CONTENT"]/div[2]/div[4]')
server_select$clickElement()
##?????۸? ?Է? ?? ?˻?
item <- remDr$findElement(using="xpath", value='//*[@id="word"]') 
item$sendKeysToElement(list("????")) 
item_search=remDr$findElement(using="xpath",value='//*[@id="g_CONTENT"]/div[2]/div[6]/ul/li[2]/span')
item_search$clickElement()

##50?? ?????? Ŭ??
item_more=remDr$findElement(using="xpath",value='//*[@id="g_CONTENT"]/div[11]')
item_more$clickElement()

#??ǰ??ü ?ܾ??��?
html = remDr$getPageSource()[[1]]
html = read_html(html)


#??ü????
normal=html_nodes(html,'#g_CONTENT > ul.search_list.search_list_normal > li') %>% html_text()
##��??
{ 
item = gsub(" ",'',normal)
item = gsub("\t\t\t\t\t.*",'',item)
item = gsub("\t\t\t\t",'',item)
item = gsub("?˴ϴ?.*",'?˴ϴ?',item)
item = gsub("??.*",'??',item)
item = gsub("?Ⱦƿ?.*",'?Ⱦƿ?',item)
item = gsub("???|??|??|??|??|??",'',item)
}


##????
{
price = gsub(" ",'',normal)
price = gsub(".*\t\t\t\t\t",'',price)
price = gsub("?ּ?.*",'',price)
price = gsub("??.*","??",price)
}

#?????? ?��??? ????
data = data.frame(item=item,price=price)
