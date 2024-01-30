public class TESTABCD {
    
  
    public Static Integer y = 10;
    
    public static void method1(Integer x){
         y = x;
        System.debug('Value after updated in method1 '+ y);
        method2();
    }
    
    public static void method2(){
        System.debug('Value after updated inmethod 2 '+ y);
    }


}