         DCL-F AutoInsDsp Workstn;
         DCL-F EXITDSP Workstn;
         DCL-S RATE zoned(3:3);
         DCL-S InsuranceRate zoned(3:3);

         EXSR CLEAR;
         EXFMT AutoInfo;
         DOW NOT(*IN03);

           IF ReplaceVal = 0;
             *IN97 = *ON;
             EXFMT AutoInfo;
             *IN97 = *OFF;
             ITER;
           ELSEIF kilometers = 0;
             *IN98 = *ON;
             EXFMT AutoInfo;
             *IN98 = *OFF;
             ITER;
           ELSEIF vYear < %DATE('1886-01-20':*ISO);
             *IN99 = *ON;
             EXFMT AutoInfo;
             *IN99 = *OFF;
             ITER;
           ELSEIF vYear > %date();
             *IN91 = *ON;
             EXFMT AutoInfo;
             *IN91 = *OFF;
             ITER;
           ELSE;
             EXSR DetermineCost;
           ENDIF;

         Write AutoInfo;
         EXFMT AutoQuote;


         IF *IN03 = *OFF;
           EXSR CLEAR;
           EXFMT AutoInfo;
         ENDIF;
         ENDDO;
       EXFMT EXITRECORD;
         SELECT;
           WHEN OPTION = 1;
            EXFMT INSUREINFO;
           WHEN OPTION = 2;
            EXFMT COMPINFO;
         ENDSL;
         *INLR = *ON;
         RETURN;

         BEGSR CLEAR;
           REPLACEVAL = 0;
           KILOMETERS = 0;
           VYEAR = D'0001-01-01';
           ACCIDENTS = 0;
           DEMERITS = 0;
           TICKETS = 0;
         ENDSR;


       BEGSR DetermineCost;
         RATE = 0.023;

         SELECT;
           WHEN KILOMETERS >= 60000;
             InsuranceRate = 0.03;
           WHEN KILOMETERS >= 40000;
             InsuranceRate = 0.026;
           WHEN KILOMETERS >= 20000;
             InsuranceRate = 0.023;
           WHEN KILOMETERS >= 10000;
             InsuranceRate = 0.02;
           WHEN KILOMETERS >= 1;
             InsuranceRate = 0.013;
         ENDSL;

        SELECT;
         WHEN DEMERITS >= 13;
           Rate += 0.03;
         WHEN ( DEMERITS >= 10 AND DEMERITS <= 12);
           Rate += 0.028;
         WHEN ( DEMERITS >= 5 AND DEMERITS <= 9);
           Rate += 0.025;
         WHEN ( DEMERITS >= 1 AND DEMERITS <= 4);
           Rate += 0.02;
        ENDSL;

        SELECT;
          WHEN ACCIDENTS = 1;
            RATE = RATE;
          WHEN ACCIDENTS = 2;
            RATE += 0.04;
          WHEN ACCIDENTS = 3;
            RATE += 0.05;
          WHEN ACCIDENTS > 3;
            RATE += 0.30;
        ENDSL;

        SELECT;
          WHEN ( TICKETS = 1 OR TICKETS = 2);
            RATE += 0.005;
          WHEN TICKETS = 3;
            RATE += 0.01;
          WHEN TICKETS >= 4;
            RATE += 0.3;
        ENDSL;

         AGE = 20;
         COST = Replaceval*RATE;
       ENDSR;                                  