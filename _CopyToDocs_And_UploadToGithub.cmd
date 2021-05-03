@echo off

:::::::::::::::::::::::::::::::
:: _site -> docs 폴더로 복사 ::
:::::::::::::::::::::::::::::::
echo Y| rmdir docs /s

mkdir docs

xcopy "_site\*.*" "docs\" /e /y

:::::::::::::::::::::::::::::::
:: 깃헙에 업로드             ::
:::::::::::::::::::::::::::::::
chcp 65001
cls

git pull

git add .

git commit -m "[%date%] Update"

:: git push
git push https://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@github.com/rito26/rito26.github.io.git

echo.======================
echo. 깃헙 업로드 완료 !
echo.======================

pause > nul