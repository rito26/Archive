@echo off
chcp 65001
cls
echo.

set strCategory=Design

set /p strTitleEn=" 영어 제목 입력 > "
set /p strTitleKr=" 한글 제목 입력 > "
set strFileDir="%date%-%strTitleEn%.md"



echo.--- >> %strFileDir%
echo.title: %strTitleKr% >> %strFileDir%
echo.author: rito26 >> %strFileDir%
echo.date: %date% %time:~0,8% +09:00 >> %strFileDir%
echo.categories: [%strCategory%] >> %strFileDir%
echo.tags: [] >> %strFileDir%
echo.math: true >> %strFileDir%
echo.mermaid: true >> %strFileDir%
echo.--- >> %strFileDir%

echo. >> %strFileDir%
echo.# >> %strFileDir%
echo.--- >> %strFileDir%
echo. >> %strFileDir%
echo.## >> %strFileDir%
echo. >> %strFileDir%
echo. >> %strFileDir%
echo. >> %strFileDir%
echo.^<!------------------------------------------------------------------^> >> %strFileDir%

pause > nul