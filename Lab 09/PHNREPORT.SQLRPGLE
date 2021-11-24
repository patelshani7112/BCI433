     A          R NEWPAGE
     A                                  2  6'User:'
     A                                  1  1'Timestamp:'
     A                                  3  3'Server:'
     A                                  1105'Page:'
     A                                  1112PAGNBR
     A            TIMESTAMP       Z     1 12
     A            USER          10      2 12
     A            SERVER        10      3 12
     A                                  2 48'P H O N E   L O G   R E P O R T'
     A                                  5 12'Sales'
     A                                  6 13'ID'
     A                                  5  2'Customer'
     A                                  5 24'Customer Name'
     A                                  6  3'Number'
     A                                  6 70'Called'
     A                                  5 54'Telephone'
     A                                  5 69'Last Date'
     A                                  5 83'Oldest Call'
     A                                  6 86'Date'
     A                                  5 97'Next Call'
     A                                  6100'Date'
     A                                  7131'*'
     A          R RPTLINE                   SPACEB(1)
     A            CSTNUM    R    5  0      3REFFLD(CUSTOMER21/CSTNUM +
     A                                      BCI433LIB/CUSTOMER21)
     A            SLSNUM    R             12REFFLD(CONTACTF21/SLSNUM +
     A                                      BCI433LIB/CONTACTF21)
     A                                      EDTCDE(J)
     A            CSTNAM    R             19REFFLD(CUSTOMER21/CSTNAM +
     A                                      BCI433LIB/CUSTOMER21)
     A            TELEPHONE R             52REFFLD(CONTACTF21/TELEPHONE +
     A                                      BCI433LIB/CONTACTF21)
     A                                      EDTWRD('0(   )&   -    ')
     A            PHNLDC    R             69REFFLD(CONTACTF21/PHNLDC +
     A                                      BCI433LIB/CONTACTF21)
     A            HIGHLIGHT      8        85
     A            NEXTCDATE       L       98
     A            ERRORMSG      15       112
     A          R SUMMARY                   SPACEB(3)
     A                                    12'S U M M A R Y   I N F O R M A T I -
     A                                      O N'
     A                                     2'CONTACTF21 Total Records:'
     A                                      SPACEB(2)
     A            CONTACTT       5  0     27EDTCDE(1)
     A                                    44'Oldest Last Callback Date:'
     A            OLDESTDATE      L       71
     A                                     2'CUSTOMER21 Total Records:'
     A                                      SPACEB(1)
     A            CUSTOMERT      5  0     27EDTCDE(1)
     A                                    39'Most Recent Last Callback Date:'
     A            MOSTRECENT      L       71
     A                                     2'Total Records with an Unknown Last-
     A                                       Callback Date:'
     A                                      SPACEB(2)
     A            UNKNOWNT       5  0     52EDTCDE(1)

     A*%%RS+<record-sequences>
     A*%%RS+ <sequence name="Untitled">
     A*%%RS+  <device type="printer" width="132" height="66" />
     A*%%RS+  <record-write record-format="NEWPAGE" />
     A*%%RS+  <record-write record-format="RPTLINE" />
     A*%%RS+  <record-write record-format="SUMMARY" />
     A*%%RS+ </sequence>
     A*%%RS </record-sequences> 