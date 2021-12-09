

        Ctl-Opt NoMain  ;


        /COPY LAB10,DAYPROTO

       Dcl-Proc DayNumName  EXPORT;

         Dcl-Pi *N CHAR(9) ;
           Number  Packed(1);
         End-PI;

          DCL-s DayName Char(9);

                 SELECT;
                     WHEN NUMBER = 1;
                     DAYNAME = 'Monday';
                     WHEN NUMBER = 2;
                     DAYNAME = 'Tuesday';
                     WHEN NUMBER = 3;
                     DAYNAME = 'Wednesday';
                     WHEN NUMBER = 4;
                     DAYNAME = 'Thursday';
                     WHEN NUMBER = 5;
                     DAYNAME = 'FRIDAY';
                     WHEN NUMBER = 6;
                     DAYNAME = 'Saturday';
                     WHEN NUMBER = 7;
                     DAYNAME = 'Sunday';
                     OTHER;
                     DAYNAME = 'Unknown';
                 ENDSL;

                 Return Dayname;
        End-Proc;

                   