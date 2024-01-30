/*
	1. A static method cannot refer a non static variable.
    Example.....
	
*/

public class AccessModiferPOCClass {
    protected String str1 ='abcd';
    private static STring str2 ='defg';
    public STring str3 ='hijk';
    
    public AccessModiferPOCClass(){
        System.debug('Str1 :: ' + str1);
        method1();
    }
    
    private void method1(){
        System.debug('Str1 :: ' + str1);
    }
    
    public  void method2(){
        System.debug('Str1 :: ' + str2);
    }

    public  void method3(){
         System.debug('Str1 :: ' + str3);
    }
}