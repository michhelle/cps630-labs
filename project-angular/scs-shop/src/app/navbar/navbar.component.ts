import { Component } from '@angular/core';
import { AuthService } from '../auth.service';
import { FormBuilder, FormGroup, FormControl, AbstractControl, Validators, ValidatorFn, ValidationErrors } from '@angular/forms';

@Component({
  selector: 'app-navbar',
  templateUrl: './navbar.component.html',
  styleUrls: ['./navbar.component.css']
})

export class NavbarComponent {
  currentUser = {};

  static LETTERS: RegExp = /[a-z]/i;
  static NUMBERS: RegExp = /[0-9]/;
  static PHONECHECK: RegExp = /^[0-9]{10}$/;
  static POSTCHECK: RegExp = /^([a-zA-Z]\d[a-zA-Z])\ {0,1}(\d[a-zA-Z]\d)$/;

  provinces = ["AB", "BC", "MB", "NB","NL","NS","NT","NU","ON","PE","QC","SK","YT"];
  defaultProvince = "ON";

  constructor (
    private auth: AuthService,
    private formBuilder: FormBuilder,
  ) {};

  loginForm = this.formBuilder.group({
    email: ["", Validators.required],
    password: ["", Validators.required]
  });

  signupForm = this.formBuilder.group({
    name: [""],
    email: ["", [Validators.required, Validators.email]],
    password: ["", [
      Validators.required, 
      Validators.minLength(8), 
      this.regexValidator({pattern: NavbarComponent.LETTERS, msg: "Password must contain at least 1 letter."}),
      this.regexValidator({pattern: NavbarComponent.NUMBERS, msg: "Password must contain at least 1 number."})
    ]],
    password_confirmation: ["", Validators.required],
    telephone: ["", [
      Validators.required,
      Validators.maxLength(10),
      this.regexValidator({pattern: NavbarComponent.PHONECHECK, msg: "Invalid phone number"})
    ]],
    streetaddr: ["", Validators.required],
    city: ["", Validators.required],
    province: ["ON", Validators.required],
    postcode: ["", [
      Validators.required,
      this.regexValidator({pattern: NavbarComponent.POSTCHECK, msg: "Invalid postal code"})
    ]]
  }, {
    validator: [this.passwordsMatch()]
  });

  regexValidator(config: any): ValidatorFn {
    return (control: AbstractControl) => {
      let regex: RegExp = config.pattern;
      if (control.value && !control.value.match(regex)) {
        return {
          invalidMsg: config.msg
        };
      } else {
        return null;
      }
    };
  }

  passwordsMatch(): ValidatorFn {
    return (control: AbstractControl) => {
      const pw = control.get("password");
      const pwc = control.get("password_confirmation");

      if (pw?.value !== pwc?.value) {
        return {
          notMatched: true
        }
      } else {
        return null;
      }
    }
  }

  onLogin() {
    //console.log(this.form.value);
    this.auth.login(this.loginForm.value.email, this.loginForm.value.password)
      .subscribe((result) => {
        console.log(result);
        this.auth.setCurrentUser(result);
        window.location.reload();
        //document.getElementById('closeLoginModal').click();
      },
      (error) => {
        console.log('login failed')
        document.getElementById('loginErrorMsg').innerHTML = "Login failed! Please check your login credentials";
      });
  }

  onSignup() {
    // everything should be validated on form side already
    this.auth.checkIfExists(this.signupForm.value.email)
      .subscribe((result) => {
        console.log(result);

        if (result.status != "OK") {
          document.getElementById('signupError').innerHTML = result.status;
          console.log(result.status);
        } else {
          this.auth.signup(this.signupForm.value)
            .subscribe((result) => {
              console.log(result);
              if (result.status == "OK") {
                document.getElementById('signupError').innerHTML = "Signup successful. Reloading in 5...";
                document.getElementById('signupError').style.color = "green";
                setTimeout(function() {
                  window.location.reload();
                }, 5000);
                console.log("signup successful");
              } else {
                document.getElementById('signupError').innerHTML = "Signup error. Please try again later.";
                console.log("signup failed");
              }
            });
        }
      })
  }

  /* setCurrentUser(userInfo: Object) {
    sessionStorage.setItem('name', userInfo["UserName"]);
    sessionStorage.setItem('email', userInfo["Email"]);
    sessionStorage.setItem('phone', userInfo["Phone"]);
    sessionStorage.setItem('address', userInfo["UserAddress"]);
    sessionStorage.setItem('postcode', userInfo["CityCode"]);
    sessionStorage.setItem('balance', userInfo["Balance"]);
  } */

  clearCurrentUser() {
    this.auth.logout();
    window.location.reload();
  }

  ngOnInit() {
    this.currentUser = {
      "name": sessionStorage.getItem('name'),
      "email": sessionStorage.getItem('email'),
      "phone": sessionStorage.getItem('phone'),
      "address": sessionStorage.getItem('address'),
      "postcode": sessionStorage.getItem('postcode'),
      "balance": sessionStorage.getItem('balance')
    }
  }

  allowDrop(event) {
    event.preventDefault();
  }

  onDrop(event) {
    event.preventDefault();
    const itemId = event.dataTransfer.getData("text");
    //console.log(itemId);

    var cartItems = {};
    if (! sessionStorage.getItem("cart")) {
      cartItems = {
        "cartItemIds": [itemId]
      }
    } else {
      cartItems = JSON.parse(sessionStorage.getItem("cart"));
      cartItems["cartItemIds"].push(itemId);
    }

    sessionStorage.setItem("cart", JSON.stringify(cartItems));
    console.log(cartItems);
  }

  getCartItemsNumber() {
    let cartItems = sessionStorage.getItem("cart");
    //console.log(cartItems.length);
    if (cartItems) {
      return JSON.parse(cartItems)["cartItemIds"].length;
    } else {
      return 0;
    }
  }
}
