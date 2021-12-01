        // ********************************************************************
        //  CUSTOMER21 READ BY NATIVE LANGUAGE (ILE RPG)
        //  CONTACTF21 ROW RETRIEVED WITH EMBEDDED SQL
        //  DETAIL REPORT LINE INCLUDES INFORMATION FROM BOTH TABLES
        //  SUMMARRY REPORT INFORMATION RETRIEVED WITH EMBEDDED SQL STATEMENTS

           DCL-F PHNREPORT PRINTER OFLIND(*IN01) ;
           DCL-F CUSTOMER21 DISK(*EXT) KEYED USAGE(*INPUT)
                 RENAME(CUSTOMER21:CUSTR);
         // data structure for host variables from CONTACTF21
               DCL-DS CONTACTF21 EXT END-DS;

         // Standalone fields for indicator variables

            DCL-S INDLastCDate  BINDEC(4:0);
            DCL-S INDNextCDate  BINDEC(4:0);

           DCL-S Dummy  Zoned(1);

        //**********************************************************************
        //*                        ***   M A I N   R O U T I N E   ***
        //**********************************************************************

                EXSR SummaryInfo;
                WRITE NEWPAGE;
                READ CUSTOMER21;
                DOW NOT %EOF;
                    EXSR SQLSelect;
                    IF *IN01 = *ON;
                       Write NEWPAGE;
                       *IN01 = *OFF;
                    ENDIF;
                    Write RPTLINE;
                   READ CUSTOMER21;
                ENDDO;
                Write SUMMARY;
                *INLR = *ON;
                RETURN;
        //**********************************************************************
        //   S Q L S E L E C T   S U B R O U T I N E
        //********************************************************************
          BEGSR    SQLSelect ;
         // A row from the CONTACTSF21 table that has the same customer number
         // as the record read from the CUSTOMER21 file is retrieved to find out
         // the last date called, phone number amd the salespersons number.

         // The call back interval is added to the last date called to determine
         //  the next date to call. Since null values may be stored in the last
         //  date called indicator variables are used.

           ErrorMsg = ' ';

           EXEC SQL
              SELECT CstLastCallDate + CstCallbackInt DAYS,
              CstLastCallDate,
              Telephone,
              CstSalesNumber
              INTO :NextCDate :INDNextCDate,
                   :PHNLDC :INDLastCDate,
                   :Telephone,
                   :SlsNum
              FROM BCI433LIB/CONTACTF21
              WHERE CustomerNumber = :CstNum;

            SELECT;
              WHEN SQLSTATE = '00000';
              DUMMY = 0;
              WHEN SQLSTATE = '02000';
               ErrorMsg = 'Match not Fount';
               Telephone = 9999999999;
               NextCDate = D'9999-09-09';
               PhnLDC = D'9999-09-09';
               SlsNum = -999;
              WHEN %SUBST(SQLSTATE :1:2) = '01';
               ErrorMsg = 'Warning Occurred';
               Telephone = 9999999999;
               NextCDate = D'9999-09-09';
               PhnLDC = D'9999-09-09';
               SlsNum = -999;
               OTHER;
               ErrorMsg = 'Error Occurred';
               Telephone = 9999999999;
               NextCDate = D'9999-09-09';
               PhnLDC = D'9999-09-09';
               SlsNum = -999;
            ENDSL;
            IF INDLastCDate = -1;
              ErrorMsg = 'Unknown Date';
               NextCDate = D'9999-09-09';
               PhnLDC = D'9999-09-09';

            ENDIF;
          ENDSR ;
        //**********************************************************************
        // S U M M A R Y I N F O   S U B R O U T I N E
        //**********************************************************************
          BEGSR  SummaryInfo;

        //  D E T E R M I N E   T O T A L S   F O R   CONTACTF21 & CUSTOMER21

        EXEC SQL
        SELECT COUNT(*) INTO :CONTACTT
          FROM BCI433LIB/CONTACTF21;

          IF (SQLCODE <> 0) OR (SQLWN0 = 'W');
            CONTACTT = -99999;
          ENDIF;

        EXEC SQL
        SELECT COUNT(*) INTO :CUSTOMERT
          FROM BCI433LIB/CUSTOMER21;

          IF (SQLCODE <> 0) OR (SQLWN0 = 'W');
            CUSTOMERT = -99999;
          ENDIF;


        // D E T E R M I N E   N U M B E R   O F   UNKNOWN  LAST DATE CALLEDS

        EXEC SQL
        SELECT COUNT(*)
          INTO :UNKNOWNT
          FROM BCI433LIB/CONTACTF21
          WHERE PHNLDC IS NULL;

          IF (SQLCODE <> 0) OR (SQLWN0 = 'W');
            UNKNOWNT = -99999;
          ENDIF;


        //  D E T E R M I N E   O L D E S T   &  MOST  RECENT LAST CALLEDS

        EXEC SQL
        SELECT min(PHNLDC), max(PHNLDC)
          INTO :OLDESTDATE, :MOSTRECENT
          FROM BCI433LIB/CONTACTF21;

        IF (SQLCODE <> 0) OR (SQLWN0 = '0') AND (SQLWN2 <> 'W');
          OLDESTDATE = D'9999-09-09';
          MOSTRECENT = D'9999-09-09';
        ENDIF;


       // D E T E R M I N E   T H E   U S E R   SERVER  &  TIMESTAMP

        EXEC SQL
        SELECT USER, CURRENT TIMESTAMP, CURRENT SERVER
          INTO :USER, :TIMESTAMP, :SERVER
          FROM SYSIBM/SYSDUMMY1;
         ENDSR;     