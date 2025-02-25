CREATE OR REPLACE PROCEDURE list_customers
IS                                  
     v_firstname        TEXT;      
     v_lastname         TEXT;   
     CURSOR emp_cur IS               
         SELECT firstname, lastname FROM customers ORDER BY lastname;
BEGIN                                               
     OPEN emp_cur;                                   
     DBMS_OUTPUT.PUT_LINE('First   Last');         
     DBMS_OUTPUT.PUT_LINE('-----   -------');       
     LOOP                                            
         FETCH emp_cur INTO v_firstname, v_lastname;        
         EXIT WHEN emp_cur%NOTFOUND;                 
         DBMS_OUTPUT.PUT_LINE(v_firstname || '   ' || v_lastname);
     END LOOP;                                               
     CLOSE emp_cur;                                          
END;                                                        
/   
