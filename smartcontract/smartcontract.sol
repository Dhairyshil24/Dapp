type Product = {
   creator : Principal;  
   productName : Text;
   productId : Nat;
   date : Text;
   totalStates : Nat;
   positions : HashMap.HashMap<Nat, State>;
};

type State  = {
   description : Text;
   person : Principal;       
};

var allProducts : HashMap.HashMap<Nat, Product> = HashMap.HashMap<Nat, Product>(0, Nat.equal, Nat.hash);
var items : Nat = 0;  

public query func searchProduct(productId : Nat) : async Text {
    let product : ?Product = allProducts.get(productId);
    switch(product) {
       case(?product) {               
           var output : Text = "Product Name: " # product.productName;  
           output #= "<br>Manufacture Date: " #  product.date;  
           for ((stateIndex,state) in product.positions.items()){
               output #= state.description;
           }    
           return output;
       };
       case(null) return "Product ID not found."; 
    }      
};     

public shared(msg) func newItem(text: Text, date: Text) : async Bool {
    items += 1;

    // Create new product  
    let newItem : Product = { 
        creator = msg.principal;
        productName = text;                      
        productId = items;  
        date = date;       
        totalStates = 0;
        positions = HashMap.HashMap<Nat, State>(0, Nat.equal, Nat.hash);
    };
    allProducts.put(items, newItem);        
    log( Nat.toText(items-1) # " added.");   
    return true;            
};
