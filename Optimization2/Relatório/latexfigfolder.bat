@echo off
set /p id= "Qual o nome da pasta onde estão as figuras?"
FOR %%f in (.\%id%\*) DO (echo \begin{figure}[H]
echo 	\begin{center}	
echo 		\includegraphics[width=8cm]{../%id%/%%~nxf}
echo 		\caption{escrevaaquiseucaption}
echo 		\label{fig:%%~nf}
echo 	\end{center}
echo \end{figure}
echo.)>>%id%.txt