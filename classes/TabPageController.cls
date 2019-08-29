/** Description         :   Class to manage TabPage functionality.
 * 
 *  Created Date        :   04/22/2015
 *
 *  Created By          :   Poonam Bhargava
 *  
 *  Version             :   V_1.0 
 * 
 *  Revision Logs       :   V_1.0 - Created 
 **/
public with sharing class TabPageController {
        
    //Create Contact list variable
    public List<Contact> contacts{get;set;}
    
    //Initialize sorting variable
    private String sortDirection = 'ASC';
    private String sortExp = 'FirstName';
    
    //Create list variable of wrapper class
    public List<WrapperTabType> wrappTabList{get;set;}
    
     //Hold Standard Set Controller Instance
     public  Apexpages.Standardsetcontroller setCont{get;set;}
     
    //Create page variable to hold size 
    public Integer selectedSize{get;set;}
    
    //Initialize constructor
    public TabPageController(ApexPages.StandardController sC) {
    
        //Function calling
        init();
    }
    
    //Init function 
    private void init() {
        
        //Memory allocation
        contacts = new List<Contact>();
        
        //Creating instance of wrapper class
        wrappTabList = new List<WrapperTabType>();
        
        //Set page variable value bydefault
        selectedSize = 4;
    
        //Assign contact list
        contacts = sortView('Reo Opportunity');
        
        //Initiallizing set Controller for the paging    
        setCont = new Apexpages.Standardsetcontroller(contacts);
        
        //Set page number
        setCont.setPageNumber(1);
        
        //Set  page size
        selectedSize = selectedSize;
        setCont.setPageSize(selectedSize);
        
        //Create temporary list of contact
        List<Contact > tcList = new List<Contact >();
        
        //Loop through records and add to temp list
        for(Sobject r:this.setCont.getRecords()){
            Contact c = (Contact )r;
            tcList.add(c);
        }
        
        //Set contact list
        contacts = tcList;
        
        //Add contacts to wrapper list
        wrappTabList.add(new WrapperTabType(contacts));
    }
    
    //Method for getting records
    private void getRecords(){
       
       System.debug('Check Get Record Called :::: ');
        
        //Check for records size 
        if(setCont.getRecords().size()>0){
          
            //Create temporary list of contact
            List<Contact > tcList = new List<Contact >();
          
            //Loop through records and add to temp list
            for(Sobject r:this.setCont.getRecords()){
                Contact c = (Contact )r;
                tcList.add(c);
            }
            
            //Set contact list
            contacts = tcList;
            
            //Creating instance of wrapper class
            wrappTabList = new List<WrapperTabType>();
            
            //Add contacts to wrapper list
            wrappTabList.add(new WrapperTabType(contacts));
            
            System.debug('Check Wrapper List Sizee :::: ' + wrappTabList.size());
        }
    }
      
    //Method for go to Next Page
    public void doNext(){
        System.debug('Check Next Called :::: ');
        
        //Check for condition
        if(setCont.getHasNext()){
            
            //Function calling
            setCont.next();
            getRecords();   
        }  
    }
    
    //Method for go Previous
    public void doPrevious(){
        
        //Check for condition
        if(setCont.getHasPrevious()){
            
            //Function calling
            setCont.previous();
            getRecords();   
        }
    }
    
    //Method for go to First Page
    public void goFirst(){
        
        System.debug('::::::goFirst:::::::' );
        
        //Function calling
        setCont.first();
        
        System.debug('::::::Check first Called:::::::');
        getRecords();
    }
         
    //Go to Last Page
    public void goLast(){
            
        //Function calling
        setCont.last();
        getRecords();
    }
        
    //Return whether previous page exists
    public Boolean getHasPrevious(){
        return this.setCont.getHasPrevious();
    }
       
    //Return whether next page exists
    public Boolean getHasNext(){
        return this.setCont.getHasNext();
    }
          
    //Return page number
    public Integer getPageNumber(){
        return this.setCont.getPageNumber();
    }
         
    //Return total pages
    public Integer getTotalPages(){
        Decimal totalSize = this.setCont.getResultSize();
        Decimal pageSize = this.setCont.getPageSize();
        Decimal pages = totalSize/pageSize; 
        return (Integer)pages.round(System.RoundingMode.CEILING);
    }
          
    //List To hold Total Paging Numbers 
    public List<Integer> pagingNumbers{
        get{
            List<Integer> numbers = new List<Integer>();
            for(Integer i=1;i<=getTotalPages();i++){
                numbers.add(i);
            }
            return numbers;       
        }
    }
    
    //Initialize sorting variable
    public String sortExpression
    {
        get
        {
            return sortExp;
        }
        set
        {
            //if the column is clicked on then switch between Ascending and Descending modes
            if (value == sortExp)
                sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
            else
                sortDirection = 'ASC';
                sortExp = value;
        }
    }

    //Get direction of sorting
    public String getSortDirection()
    {
        //if not column is selected 
        if (sortExpression == null || sortExpression == '')
            return 'ASC';
        else
            return sortDirection;
    }

    //Set direction
    public void setSortDirection(String value)
    {  
        sortDirection = value;
    }
    
    //Method for Populate records and add to wrapper list
    public void ViewData() {
       
        //Creating instance of wrapper class
        wrappTabList = new List<WrapperTabType>();
        
        //Populate contact list
        List<Contact> contList = sortView('Reo Opportunity');
        
        System.debug('Check Contact list size :::: ' + contList.size());
        
        //Initiallizing set Controller for the paging    
        setCont = new Apexpages.Standardsetcontroller(contList);
        
        //Set page number
        setCont.setPageNumber(getPageNumber());
        
        //Set  page size
        selectedSize = selectedSize;
        setCont.setPageSize(selectedSize);
        
        //Function calling
        getRecords();
        
    }
  
    //Creating list of contact
    public List<Contact> sortView(String cate) {
       
        //build the full sort expression
        string sortFullExp = sortExpression  + ' ' + sortDirection;
        
        System.debug('Check Sort Expression :::: ' + sortFullExp);
        
        //String variable
        String filterSoql = '';
       
        //Deault Initialize List       
        filterSoql = 'select Name, Id, FirstName, LastName from Contact  order by ' + sortFullExp + ' nulls last limit 1000';       
        
        //Return list
        return (List<Contact>)Database.query(filterSoql);    
    }
    
    //=======================================================================Wrapper Class========================================================================  
    /**
    *   Wrapper Class to Hold Contact Properties
    **/
    public class WrapperTabType {
    
        //Create list variable of contact    
        public List<Contact> cons{get; set;}
       
        //Initialize constructor
        public WrapperTabType(List<Contact> cons) {
            
            //Initiaize default Contact List
            this.cons = cons;    
        }
    }
}