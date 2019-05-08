참조 사이트(https://www.r-bloggers.com/how-to-run-r-from-the-task-scheduler/)

# Task Scheduler(Windows10)를 사용한 R 파일 스케줄링 방법 

### 스케줄러 사용 목적
> **장기적**으로 R파일을 **원하는 시간**에 **실행**하여 **데이터를 저장**하기 위한 것으로 화면으로 출력시켜서 보려는 실행코드는 실제 눈으로 보이지 않는다.

## 실행 전 필요한 것

1. 자신의 Rscript 디렉토리. 
2. 실행할 R파일. 
(준비가 안 되었다면 예시를 보고 따라 하자)[]

## 스케줄러 방법

1. 작업 스케줄러를 킨다.














## 실행 방법

C:\bin\x64\Rscript.exe : 자신의 Rscript 디렉토리. 
test.R : 실행할 R파일. 

### Rscript 찾는 방법

```r
.libPaths()
```

함수를 사용하면 R-3.5.0이 포함되어 있는 [*C:/Program Files/R/R-3.5.0/library*]에서 library => bin/Rscript.exe로 하면 된다.
[*C:/Program Files/R/R-3.5.0/library*] => [*C:/Program Files/R/R-3.5.0/bin/Rscript.exe*]

### 실행할 R파일 예제파일 저장
```r
Path = "C:/" # URL
t = list.files(path=Path, pattern = ".csv")
l = c(1,2,3,4,5)
if(length(t)==0){
  write.csv(l,paste0(Path,"test1.csv"),row.names = F)
}else{
  t = max(as.numeric(gsub("test|.csv","",t)))+1
  write.csv(l,paste0(Path,"test",t,".csv"),row.names = F)
}
```
