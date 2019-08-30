public class AdvanceChatterPageController {
    
    public String val{get;set;}
    public List<SelectOption> UserOptions{get;set;}
    
    
    public String showVal{get;set;}
    public List<SelectOption> showOptions{get;set;}
    public  List<FeedItem> feedFiles{get;set;}
    
    public AdvanceChatterPageController() {
    
        val = Userinfo.getUserId(); 
        UserOptions = new List<SelectOption>();
        
        for(User u : [Select Id, Name from User where IsActive = true order by Name ASC]){
            UserOptions.add(new SelectOption(u.Id, u.Name));
        }
    
         
        feedFiles = [select id, title, Body, parentid from feeditem where parentid = '0017F00000TwUP1'];   
        
        showOptions = new List<SelectOption>();
        showOptions.add(new SelectOption('All Update', 'All Update'));
        showOptions.add(new SelectOption('Latest Posts', 'Latest Posts'));
      
    }
   
    
    
    
}