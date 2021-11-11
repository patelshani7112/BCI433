       DCL-F SHIFTWEEK USAGE(*INPUT) KEYED RENAME(SHIFTWEEK:SHIFTWEEKR);
       DCL-F PAYSUMMAR2 WORKSTN;
       DCL-F SHIFTRATES DISK USAGE(*INPUT) RENAME(SHIFTRATES:SHIFTRATER);
       DCL-F PAYRPT2 PRINTER OFLIND(*IN01);

       DCL-S HOURSOVER PACKED(3);
       DCL-PI MAIN EXTPGM('PAYROLLPG3');
         SHIFTTYPE CHAR(30);
       END-PI;

       READ SHIFTRATES;
       WRITE TITLE;
       WRITE COLHDG;
       READ SHIFTWEEK;

       *IN01 = *ON;

         READ SHIFTWEEK;

       DOW NOT %EOF(SHIFTWEEK);
         EXSR PAYSR;
         IF *IN01;
           Write Title;
           Write ColHdg;
           *IN01 = *OFF;
         ENDIF;

       Write EmpDetail;
       READ SHIFTWEEK;
       ENDDO;

       TOTWKPAY = TOTREGPAY + TOTOVTPAY;
       WRITE TOTALS;
       EXFMT RECORD1;
       *INLR = *ON;
       RETURN;

       BEGSR PAYSR;
         SELECT;
           WHEN WORKSHIFT = '1';
              HOURLYRATE = DAYHRS;
           WHEN WORKSHIFT = '2';
              HOURLYRATE = AFTHRS;
           WHEN WORKSHIFT = '3';
              HOURLYRATE = NIGHTHRS;
         ENDSL;

        SELECT;
           WHEN PAYCLASS =  1 ;
              EVAL(H) HOURLYRATE = HOURLYRATE * 1.094;
           WHEN PAYCLASS =  2 ;
              EVAL(H) HOURLYRATE = HOURLYRATE * 1.062;
           WHEN PAYCLASS =  3 ;
              EVAL(H) HOURLYRATE = HOURLYRATE * 0.957;
        ENDSL;

                        HOURSOVER = HRSWORKED - 40;

                        SELECT;
                        WHEN HOURSOVER > 0;
                          EVAL(H) OVERPAY = HOURLYRATE * 1.5 * HOURSOVER;
                          EVAL REGULARPAY = 40 * HOURLYRATE;
                 OTHER;
                          EVAL REGULARPAY = HRSWORKED * HOURLYRATE;
                          OVERPAY = 0;
                        ENDSL;

                        WEEKLYPAY = REGULARPAY + OVERPAY;

                        TOTREGPAY = TOTREGPAY + REGULARPAY;
                        TOTOVTPAY = TOTOVTPAY + OVERPAY;

       ENDSR;

                        