

        Ctl-Opt NoMain DatFmt(*USA);


        /COPY LAB10,DAYPROTO

       Dcl-Proc DayNumName  EXPORT;

         Dcl-Pi *N CHAR(9) ;
           Number  Packed(1);
         End-PI;

          DCL-s DayName Char(9);

       Dcl-DS DayData;
             *n Char(9) Inz('Monday');
             *n Char(9) Inz('Tuesday');
             *n Char(9) Inz('Wednesday');
             *n Char(9) Inz('Thursday');
             *n Char(9) Inz('Friday');
             *n Char(9) Inz('Saturday');
             *n Char(9) Inz('Sunday');

             DayArray Char(9) Dim(7) Pos(1);

       END-DS;

            Return DayArray(Number);
       END-PROC;
                   