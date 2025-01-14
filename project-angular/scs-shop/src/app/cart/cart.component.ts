import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService } from '../auth.service';
import { ItemService } from '../item.service';

@Component({
  selector: 'app-cart',
  templateUrl: './cart.component.html',
  styleUrls: ['./cart.component.css']
})
export class CartComponent {
  availableItems : any;
  cartItems;
  fullCart = []

  constructor(
    private itemService: ItemService,
    private router: Router,
    private auth: AuthService
  ) { }

  ngOnInit() {
    //console.log(this.auth.loggedIn());
    console.log(this.auth.getCurrentUser());      
    this.itemService.getItems()
      .subscribe(response => {
        this.availableItems = response;
        //console.log(this.availableItems);

        this.cartItems = sessionStorage.getItem("cart");
        //console.log(this.cartItems);
        if (this.cartItems) {
          this.fullCart = this.mapCartItems(JSON.parse(this.cartItems)["cartItemIds"]);
        }
        
        //console.log(this.fullCart)
      });
  }

  // item ids from cart => full item info
  mapCartItems(cart: Array<string>) {
    let itemList = cart.map((id) => {
      // const itemInfo = this.availableItems.filter(item => item.ItemID == id)[0];
      // itemInfo.InCart = 1;
      return this.availableItems.filter(item => item.ItemID == id)[0];
    })
    //console.log(itemList)
    return itemList;
  }
  
  clearCart() {
    sessionStorage.removeItem("cart");
    window.location.reload();
  }

  // deleteItem() {
  //   console.log(event.target)
  // }

  cartSubtotal() {
    let prices = this.fullCart.map((item) => {
      return item.ItemPrice;
    })
    const subtotal = prices.reduce((a, b) => a + b, 0);
    return subtotal;
  }

  checkout() {
    sessionStorage.setItem("fullCart", JSON.stringify(this.fullCart));
    this.router.navigate(['/checkout']);
  }

  loggedIn() {
    return this.auth.loggedIn();
  }
}
