public with sharing class CommunitiesLoginController1 {
    public String username{get;set;}
    public String password{get;set;}
    public CommunitiesLoginController1() {}

    public Pagereference doLogin(){
        return Site.login(username, password, null);
    }


}