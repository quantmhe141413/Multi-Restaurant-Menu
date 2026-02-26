<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!-- Reusable Confirm Modal Component -->
<div class="modal fade" id="confirmModal" tabindex="-1" aria-labelledby="confirmModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius: 12px; border: none; box-shadow: 0 4px 20px rgba(0,0,0,0.15);">
            <div class="modal-header" style="border-bottom: 1px solid #e9ecef; padding: 1.5rem;">
                <h5 class="modal-title" id="confirmModalLabel" style="font-weight: 600; color: #2f3542;">
                    <i class="fas fa-exclamation-circle text-warning"></i>
                    <span id="confirmModalTitle">Xác nhận</span>
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" style="padding: 1.5rem;">
                <p id="confirmModalMessage" style="font-size: 1rem; color: #495057; margin: 0;">
                    Bạn có chắc chắn muốn thực hiện thao tác này?
                </p>
            </div>
            <div class="modal-footer" style="border-top: 1px solid #e9ecef; padding: 1rem 1.5rem;">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" style="padding: 0.5rem 1.5rem; border-radius: 8px;">
                    <i class="fas fa-times"></i> Hủy
                </button>
                <button type="button" class="btn btn-primary" id="confirmModalConfirmBtn" style="padding: 0.5rem 1.5rem; border-radius: 8px; background-color: #ff4757; border: none;">
                    <i class="fas fa-check"></i> Xác nhận
                </button>
            </div>
        </div>
    </div>
</div>

<script>
// Reusable Confirm Modal JavaScript
(function() {
    window.ConfirmModal = {
        show: function(options) {
            // Default options
            var defaults = {
                title: 'Xác nhận',
                message: 'Bạn có chắc chắn muốn thực hiện thao tác này?',
                confirmText: 'Xác nhận',
                cancelText: 'Hủy',
                confirmBtnClass: 'btn-primary',
                confirmBtnStyle: 'background-color: #ff4757; border: none;',
                icon: 'fas fa-exclamation-circle text-warning',
                onConfirm: function() {},
                onCancel: function() {}
            };
            
            // Merge options with defaults
            var settings = Object.assign({}, defaults, options);
            
            // Get modal elements
            var modal = document.getElementById('confirmModal');
            var modalTitle = document.getElementById('confirmModalTitle');
            var modalMessage = document.getElementById('confirmModalMessage');
            var confirmBtn = document.getElementById('confirmModalConfirmBtn');
            var titleIcon = modal.querySelector('.modal-title i');
            
            // Set content
            modalTitle.textContent = settings.title;
            modalMessage.textContent = settings.message;
            confirmBtn.innerHTML = '<i class="fas fa-check"></i> ' + settings.confirmText;
            
            // Set icon
            titleIcon.className = settings.icon;
            
            // Set button style
            confirmBtn.className = 'btn ' + settings.confirmBtnClass;
            confirmBtn.style.cssText = settings.confirmBtnStyle + ' padding: 0.5rem 1.5rem; border-radius: 8px;';
            
            // Remove old event listeners by cloning
            var newConfirmBtn = confirmBtn.cloneNode(true);
            confirmBtn.parentNode.replaceChild(newConfirmBtn, confirmBtn);
            confirmBtn = newConfirmBtn;
            
            // Add new event listener
            confirmBtn.addEventListener('click', function() {
                settings.onConfirm();
                var modalInstance = bootstrap.Modal.getInstance(modal);
                if (modalInstance) {
                    modalInstance.hide();
                }
            });
            
            // Handle cancel button
            var cancelBtns = modal.querySelectorAll('[data-bs-dismiss="modal"]');
            cancelBtns.forEach(function(btn) {
                var newBtn = btn.cloneNode(true);
                btn.parentNode.replaceChild(newBtn, btn);
                newBtn.addEventListener('click', function() {
                    settings.onCancel();
                });
            });
            
            // Show modal
            var modalInstance = new bootstrap.Modal(modal);
            modalInstance.show();
        }
    };
})();
</script>

<style>
    #confirmModal .modal-content {
        animation: modalFadeIn 0.3s ease-out;
    }
    
    @keyframes modalFadeIn {
        from {
            opacity: 0;
            transform: translateY(-20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
    
    #confirmModal .btn:hover {
        transform: translateY(-1px);
        box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        transition: all 0.2s;
    }
    
    #confirmModal .btn-secondary {
        background-color: #6c757d;
        border: none;
    }
    
    #confirmModal .btn-secondary:hover {
        background-color: #5a6268;
    }
</style>
