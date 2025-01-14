<?php session_start(); ?>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Items</title>
  <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🛒</text></svg>">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD" crossorigin="anonymous">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
  <script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDgEhxoik76va_nhG6KsA4DTa5JBr_Iz0I&callback=initMap"></script>

  <?php
  include "phpScripts/DBConnect.php";
  include "phpScripts/Product.php";
  include "phpScripts/RenderList.php";
  ?>
</head>

<body>
  <?php
  if (isset($_SESSION['email'])) {
    include 'navbar2.php';
  } else {
    include 'navbar.php';
  }
  include 'storeSelector.html';

  if (isset($_POST['addToCart']) && isset($_SESSION['email'])) {
    // Sanitize and validate the input values
    $productID = $_POST['productID'];
    $productName = $_POST['productName'];
    $productSize = $_POST['productSize'];
    $productQuantity = $_POST['productQuantity'];
    $productPrice = $_POST['productPrice'];
    $productImageURL = $_POST['productImageURL'];

    // Create a new array with the product details
    $session_array = array(
      "productID" => $productID,
      "productName" => $productName,
      "productSize" => $productSize,
      "productQuantity" => $productQuantity,
      "productPrice" => $productPrice,
      "productImageURL" => $productImageURL
    );

    // Check if the cart is empty
    if (empty($_SESSION['cart'])) {
      // Create a new cart session variable with the product details
      $_SESSION['cart'][] = $session_array;
    } else {
      // Check if the product already exists in the cart
      $product_exists = false;
      foreach ($_SESSION['cart'] as &$cart_item) {
        if ($cart_item['productID'] == $productID) {
          // Increase the quantity of the existing product
          $cart_item['productQuantity'] += $productQuantity;
          $product_exists = true;
          break;
        }
      }

      // If the product doesn't exist in the cart, add it
      if (!$product_exists) {
        $_SESSION['cart'][] = $session_array;
      }
    }
  } else if (isset($_POST['addToCart']) && (!isset($_SESSION['email']))) { ?>
    <div class="alert alert-warning alert-dismissible fade show m-1" role="alert">
      <strong>You have to log in first before adding items to cart.</strong>
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
  <?php } ?>
  <div class="container">
    <h1>Items</h1>

    <ul class="nav nav-tabs">
      <li class="nav-item">
        <a class="nav-link active" href="#">All</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="#tops">Tops</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="#outer">Outerwear</a>
      </li>
    </ul>

    <div id="itemList" class="container text-center">
      <?php
      $result = $connection->query("select * from Item");
      $items = [];
      if ($result) {
        while ($item = $result->fetch_assoc()) {
          //echo ("{$item['ItemName']}, {$item['ItemPrice']}<br>");
          $items[] = new Product($item['ItemID'], $item['ItemName'], $item['ItemPrice'], $item['Picture_URL']);
        }
      }

      $output = "<div class='row align-items-center gap-3'>";
      foreach ($items as $item) {
        $output .= $item->renderHtml();
      }

      $output .= "</div>";

      echo ($output);
      var_dump($_SESSION['cart']);
      ?>

    </div>
  </div>
  </div>
</body>

<script>
  async function codeAddress(apiUrl) {
    fetch(apiUrl)
      .then(response => response.json())
      .then(data => {
        console.log(data)
        var city = data.address.city
        var postal = data.address.postcode
        findStores(city, postal)
      })
      .catch(error => {
        document.getElementById('postalCode').innerHTML = "Location not found"
      });
  }

  function findStores(city, postcode) {
    document.getElementById('postalCode').innerHTML = postcode
    switch (city) {
      case 'Toronto':
        document.getElementById('storeLocation').innerHTML = "Queen St W, Toronto"
        break
      case 'Markham':
        document.getElementById('storeLocation').innerHTML = "CF Markville, Markham"
        break
      case 'Mississauga':
        document.getElementById('storeLocation').innerHTML = "Square One Shopping Centre, Mississauga"
      default:
        document.getElementById('storeLocation').innerHTML = "No store selected"
    }
  }

  function getLocation() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(getCoords);
    } else {
      alert("Geolocation is not supported by this browser");
    }
  }

  function getCoords(position) {
    var address = position.coords.latitude + ',' + position.coords.longitude;
    var apiUrl = `https://geocode.maps.co/reverse?lat=${position.coords.latitude}&lon=${position.coords.longitude}`
    codeAddress(apiUrl);
  }

  function selectStore() {
    const selectButtons = document.querySelectorAll('.store');

    selectButtons.forEach(button => {
      button.addEventListener('click', () => {
        const storeName = button.closest('.store').querySelector('.store-name').textContent;

        document.getElementById('storeLocation').innerHTML = storeName;
      });
    });
  }
</script>

</html>