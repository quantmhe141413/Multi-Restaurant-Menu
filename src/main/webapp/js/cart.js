// Cart management for Staff POS System

// Cart data structure
let cart = [];
let currentItemToAdd = null;

// Initialize on page load
document.addEventListener('DOMContentLoaded', function() {
    // Attach click handlers to menu item cards
    document.querySelectorAll('.menu-item-card').forEach(card => {
        card.addEventListener('click', function() {
            const itemId = parseInt(this.dataset.itemId);
            const itemName = this.dataset.itemName;
            const price = parseFloat(this.dataset.itemPrice);
            showAddItemModal(itemId, itemName, price);
        });
    });

    // Show/hide delivery address based on order type
    document.querySelectorAll('input[name="orderType"]').forEach(radio => {
        radio.addEventListener('change', function() {
            const deliveryAddressGroup = document.getElementById('deliveryAddressGroup');
            if (this.value === 'Online') {
                deliveryAddressGroup.style.display = 'block';
            } else {
                deliveryAddressGroup.style.display = 'none';
            }
            calculateTotals();
        });
    });

    // Enable/disable confirm button based on cart
    updateConfirmButton();
});

/**
 * Show modal to add item to cart
 */
function showAddItemModal(itemId, itemName, price) {
    currentItemToAdd = {
        itemId: itemId,
        itemName: itemName,
        price: price
    };
    
    document.getElementById('modalItemName').textContent = itemName;
    document.getElementById('modalItemPrice').textContent = formatCurrency(price);
    document.getElementById('modalQuantity').value = 1;
    document.getElementById('modalNote').value = '';
    
    const modal = new bootstrap.Modal(document.getElementById('addItemModal'));
    modal.show();
}

/**
 * Add item to cart
 */
function addToCart() {
    if (!currentItemToAdd) return;
    
    const quantity = parseInt(document.getElementById('modalQuantity').value);
    const note = document.getElementById('modalNote').value.trim();
    
    if (quantity < 1) {
        alert('Số lượng phải lớn hơn 0');
        return;
    }
    
    // Check if item already exists in cart
    const existingItemIndex = cart.findIndex(item => 
        item.itemId === currentItemToAdd.itemId && item.note === note
    );
    
    if (existingItemIndex >= 0) {
        // Update quantity if item with same note exists
        cart[existingItemIndex].quantity += quantity;
    } else {
        // Add new item to cart
        cart.push({
            itemId: currentItemToAdd.itemId,
            itemName: currentItemToAdd.itemName,
            unitPrice: currentItemToAdd.price,
            quantity: quantity,
            note: note,
            lineTotal: currentItemToAdd.price * quantity
        });
    }
    
    // Close modal
    const modal = bootstrap.Modal.getInstance(document.getElementById('addItemModal'));
    modal.hide();
    
    // Update cart display
    renderCart();
    calculateTotals();
    updateConfirmButton();
}

/**
 * Update quantity of item in cart
 */
function updateQuantity(index, newQuantity) {
    if (newQuantity < 1) {
        removeFromCart(index);
        return;
    }
    
    cart[index].quantity = newQuantity;
    cart[index].lineTotal = cart[index].unitPrice * newQuantity;
    
    renderCart();
    calculateTotals();
}

/**
 * Remove item from cart
 */
function removeFromCart(index) {
    if (confirm('Bạn có chắc muốn xóa món này khỏi giỏ hàng?')) {
        cart.splice(index, 1);
        renderCart();
        calculateTotals();
        updateConfirmButton();
    }
}

/**
 * Render cart items
 */
function renderCart() {
    const cartItemsContainer = document.getElementById('cartItems');
    
    if (cart.length === 0) {
        cartItemsContainer.innerHTML = `
            <div class="empty-cart">
                <i class="bi bi-cart-x" style="font-size: 4rem;"></i>
                <p class="mt-3">Giỏ hàng trống<br>Vui lòng chọn món ăn từ menu</p>
            </div>
        `;
        return;
    }
    
    let html = '';
    cart.forEach((item, index) => {
        html += `
            <div class="cart-item">
                <div class="d-flex justify-content-between align-items-start mb-2">
                    <div class="flex-grow-1">
                        <h6 class="mb-1">${item.itemName}</h6>
                        <p class="text-muted small mb-1">${formatCurrency(item.unitPrice)} đ</p>
                        ${item.note ? `<p class="text-muted small mb-0"><i class="bi bi-chat-left-text"></i> ${item.note}</p>` : ''}
                    </div>
                    <button class="btn btn-sm btn-outline-danger" onclick="removeFromCart(${index})">
                        <i class="bi bi-trash"></i>
                    </button>
                </div>
                <div class="d-flex justify-content-between align-items-center">
                    <div class="quantity-control">
                        <button class="btn btn-sm btn-outline-secondary quantity-btn" onclick="updateQuantity(${index}, ${item.quantity - 1})">
                            <i class="bi bi-dash"></i>
                        </button>
                        <input type="number" class="form-control form-control-sm quantity-input" 
                               value="${item.quantity}" min="1" 
                               onchange="updateQuantity(${index}, parseInt(this.value))">
                        <button class="btn btn-sm btn-outline-secondary quantity-btn" onclick="updateQuantity(${index}, ${item.quantity + 1})">
                            <i class="bi bi-plus"></i>
                        </button>
                    </div>
                    <strong class="text-primary">${formatCurrency(item.lineTotal)} đ</strong>
                </div>
            </div>
        `;
    });
    
    cartItemsContainer.innerHTML = html;
}

/**
 * Calculate and display totals
 */
function calculateTotals() {
    // Calculate subtotal
    const subtotal = cart.reduce((sum, item) => sum + item.lineTotal, 0);
    
    // Discount (placeholder - will be implemented in Phase 5)
    const discount = 0;
    
    // Delivery fee (only for Online orders)
    const orderType = document.querySelector('input[name="orderType"]:checked').value;
    const deliveryFee = orderType === 'Online' ? 30000 : 0; // Default 30,000 VND
    
    // Final amount
    const finalAmount = subtotal - discount + deliveryFee;
    
    // Update display
    document.getElementById('subtotal').textContent = formatCurrency(subtotal) + ' đ';
    document.getElementById('discount').textContent = formatCurrency(discount) + ' đ';
    document.getElementById('deliveryFee').textContent = formatCurrency(deliveryFee) + ' đ';
    document.getElementById('finalAmount').textContent = formatCurrency(finalAmount) + ' đ';
}

/**
 * Update confirm button state
 */
function updateConfirmButton() {
    const confirmBtn = document.getElementById('confirmOrderBtn');
    confirmBtn.disabled = cart.length === 0;
}

/**
 * Format number as currency
 */
function formatCurrency(amount) {
    return new Intl.NumberFormat('vi-VN').format(amount);
}

/**
 * Validate and submit order
 */
document.getElementById('confirmOrderBtn')?.addEventListener('click', function() {
    // Validate order info
    const orderType = document.querySelector('input[name="orderType"]:checked').value;
    const deliveryAddress = document.getElementById('deliveryAddress').value.trim();
    
    if (orderType === 'Online' && !deliveryAddress) {
        alert('Vui lòng nhập địa chỉ giao hàng');
        document.getElementById('deliveryAddress').focus();
        return;
    }
    
    if (cart.length === 0) {
        alert('Giỏ hàng trống, vui lòng chọn món ăn');
        return;
    }
    
    // Submit order directly (payment will be done later)
    submitOrder(orderType, deliveryAddress, 'Cash');
});

/**
 * Submit order to server via form POST
 */
function submitOrder(orderType, deliveryAddress, paymentMethod) {
    // Get table ID from URL
    const urlParams = new URLSearchParams(window.location.search);
    const tableId = urlParams.get('tableId');
    
    // Get discount code if entered
    const discountCode = document.getElementById('discountCode')?.value.trim() || '';
    
    // Create form
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = window.location.pathname.replace('/staff/pos', '/staff/order/create');
    
    // Add form fields
    const fields = {
        tableId: tableId || '',
        orderType: orderType,
        deliveryAddress: deliveryAddress,
        discountCode: discountCode,
        paymentMethod: paymentMethod,
        cartItems: JSON.stringify(cart)
    };
    
    for (const [key, value] of Object.entries(fields)) {
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = key;
        input.value = value;
        form.appendChild(input);
    }
    
    // Submit form
    document.body.appendChild(form);
    form.submit();
}

/**
 * Show VNPay QR code modal
 */
function showVNPayQR() {
    // Calculate final amount
    const subtotal = cart.reduce((sum, item) => sum + item.lineTotal, 0);
    const orderType = document.querySelector('input[name="orderType"]:checked').value;
    const deliveryFee = orderType === 'Online' ? 30000 : 0;
    const finalAmount = subtotal + deliveryFee;
    
    // Update amount in modal
    document.getElementById('vnpayAmount').textContent = formatCurrency(finalAmount);
    
    // Generate QR code with payment info
    const qrData = encodeURIComponent(`VNPAY|${finalAmount}|${Date.now()}`);
    document.getElementById('vnpayQRImage').src = 
        `https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=${qrData}`;
    
    // Show modal
    const modal = new bootstrap.Modal(document.getElementById('vnpayQRModal'));
    modal.show();
}

/**
 * Confirm VNPay payment and submit order
 */
function confirmVNPayPayment() {
    const orderType = document.querySelector('input[name="orderType"]:checked').value;
    const deliveryAddress = document.getElementById('deliveryAddress').value.trim();
    
    // Close modal
    const modal = bootstrap.Modal.getInstance(document.getElementById('vnpayQRModal'));
    modal.hide();
    
    // Submit order
    submitOrder(orderType, deliveryAddress, 'VNPay');
}

/**
 * Select payment method and update UI
 */
function selectPaymentMethod(method) {
    // Update radio button
    document.getElementById('payment' + method).checked = true;
    
    // Update card styles
    document.querySelectorAll('.payment-method-card').forEach(card => {
        card.classList.remove('selected');
    });
    event.currentTarget.classList.add('selected');
}
