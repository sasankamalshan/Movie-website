<template>
  <section class="contact" id="contact">
    <div class="container">
      <div class="section-header">
        <h2 class="section-title fade-in">How to reach us</h2>
        <p class="section-subtitle fade-in">Send us a message and we'll respond as soon as possible.</p>
      </div>

      <div class="contact-content">
        <!-- Contact Form -->
        <div class="contact-form-container slide-in-left">
          <form @submit.prevent="handleSubmit" class="contact-form" novalidate>
            <div class="form-row">
              <div class="form-group">
                <label for="firstName">First Name *</label>
                <input
                  type="text"
                  id="firstName"
                  v-model="form.firstName"
                  :class="{ error: errors.firstName }"
                  @blur="validateField('firstName')"
                  @input="clearError('firstName')"
                  autocomplete="given-name"
                  required
                />
                <span v-if="errors.firstName" class="error-message">{{ errors.firstName }}</span>
              </div>

              <div class="form-group">
                <label for="lastName">Last Name *</label>
                <input
                  type="text"
                  id="lastName"
                  v-model="form.lastName"
                  :class="{ error: errors.lastName }"
                  @blur="validateField('lastName')"
                  @input="clearError('lastName')"
                  autocomplete="family-name"
                  required
                />
                <span v-if="errors.lastName" class="error-message">{{ errors.lastName }}</span>
              </div>
            </div>

            <div class="form-group">
              <label for="email">Email Address *</label>
              <input
                type="email"
                id="email"
                v-model="form.email"
                :class="{ error: errors.email }"
                @blur="validateField('email')"
                @input="clearError('email')"
                autocomplete="email"
                required
              />
              <span v-if="errors.email" class="error-message">{{ errors.email }}</span>
            </div>

            <div class="form-group">
              <label for="telephone">Telephone</label>
              <input
                type="tel"
                id="telephone"
                v-model="form.telephone"
                :class="{ error: errors.telephone }"
                @blur="validateField('telephone')"
                @input="clearError('telephone')"
                autocomplete="tel"
              />
              <span v-if="errors.telephone" class="error-message">{{ errors.telephone }}</span>
            </div>

            <div class="form-group">
              <label for="message">Message *</label>
              <textarea
                id="message"
                v-model="form.message"
                :class="{ error: errors.message }"
                @blur="validateField('message')"
                @input="clearError('message')"
                rows="6"                
                required
              ></textarea>
              <span v-if="errors.message" class="error-message">{{ errors.message }}</span>
            </div>

            <!-- Required Fields Note and Terms Checkbox -->
            <div class="form-footer">
              <div class="required-note">
                <span class="required-text">* required fields</span>
              </div>
              
              <div class="terms-group">
                <div class="checkbox-wrapper">
                  <input
                    type="checkbox"
                    id="terms"
                    v-model="form.agreeToTerms"
                    :class="{ error: errors.agreeToTerms }"
                    @change="validateField('agreeToTerms')"
                    required
                  />
                  <label for="terms" class="checkbox-label">
                    I agree to the Terms & Conditions
                  </label>
                </div>
                <span v-if="errors.agreeToTerms" class="error-message">{{ errors.agreeToTerms }}</span>
              </div>
            </div>

            <div class="form-actions">
              <button 
                type="submit" 
                class="btn btn-primary submit-btn"
                :disabled="isSubmitting"
              >
                <span v-if="!isSubmitting">Submit</span>
                <span v-else class="submitting">
                  <div class="spinner"></div>
                  Submitting...
                </span>
              </button>
            </div>
          </form>

          <!-- Success Message -->
          <div v-if="submitted" class="success-message">
            <div class="success-icon">
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M9 12L11 14L15 10M21 12C21 16.9706 16.9706 21 12 21C7.02944 21 3 16.9706 3 12C3 7.02944 7.02944 3 12 3C16.9706 3 21 7.02944 21 12Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </div>
            <h3>Message Sent Successfully!</h3>
            <p>Thank you for your message. We'll get back to you soon.</p>
            <button @click="resetForm" class="btn btn-outline">Send Another Message</button>
          </div>
        </div>

        <!-- Map Container -->
        <div class="map-container slide-in-right">
          <div class="map-wrapper">
            <iframe 
              src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2887.0926853793935!2d7.069464915773547!3d43.617570779122095!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x12ce1f8b6b8b6b8b%3A0x8b8b8b8b8b8b8b8b!2sAmadeus%20IT%20Group%2C%20485%20Rte%20du%20Pin%20Montard%2C%2006902%20Sophia%20Antipolis%2C%20France!5e0!3m2!1sen!2sus!4v1691234567890!5m2!1sen!2sus"
              class="google-map-iframe"
              allowfullscreen=""
              loading="lazy"
              referrerpolicy="no-referrer-when-downgrade"
              title="Amadeus IT Group Location">
            </iframe>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
export default {
  name: 'ContactSection',
  data() {
    return {
      form: {
        firstName: '',
        lastName: '',
        email: '',
        telephone: '',
        message: '',
        agreeToTerms: false
      },
      errors: {},
      isSubmitting: false,
      submitted: false
    }
  },
  mounted() {
    this.setupIntersectionObserver()
    this.setupIntersectionObserver()
  },
  methods: {
    validateField(fieldName) {
      const value = this.form[fieldName]?.trim()
      
      switch (fieldName) {
        case 'firstName':
          if (!value) {
            this.errors.firstName = 'First name is required'
          } else if (value.length < 2) {
            this.errors.firstName = 'First name must be at least 2 characters'
          } else {
            delete this.errors.firstName
          }
          break
          
        case 'lastName':
          if (!value) {
            this.errors.lastName = 'Last name is required'
          } else if (value.length < 2) {
            this.errors.lastName = 'Last name must be at least 2 characters'
          } else {
            delete this.errors.lastName
          }
          break
          
        case 'email':
          const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
          if (!value) {
            this.errors.email = 'Email address is required'
          } else if (!emailRegex.test(value)) {
            this.errors.email = 'Please enter a valid email address'
          } else {
            delete this.errors.email
          }
          break

        case 'telephone':
          const phoneRegex = /^[\+]?[1-9][\d]{0,15}$/
          if (value && !phoneRegex.test(value.replace(/[\s\-\(\)]/g, ''))) {
            this.errors.telephone = 'Please enter a valid telephone number'
          } else {
            delete this.errors.telephone
          }
          break
          
        case 'message':
          if (!value) {
            this.errors.message = 'Message is required'
          } else if (value.length < 10) {
            this.errors.message = 'Message must be at least 10 characters'
          } else {
            delete this.errors.message
          }
          break

        case 'agreeToTerms':
          if (!this.form.agreeToTerms) {
            this.errors.agreeToTerms = 'You must agree to the Terms & Conditions'
          } else {
            delete this.errors.agreeToTerms
          }
          break
      }
    },
    
    clearError(fieldName) {
      if (this.errors[fieldName]) {
        delete this.errors[fieldName]
      }
    },
    
    validateForm() {
      this.validateField('firstName')
      this.validateField('lastName')
      this.validateField('email')
      this.validateField('telephone')
      this.validateField('message')
      this.validateField('agreeToTerms')
      
      return Object.keys(this.errors).length === 0
    },
    
    async handleSubmit() {
      if (!this.validateForm()) {
        // Focus on first error field
        const firstErrorField = Object.keys(this.errors)[0]
        const element = document.getElementById(firstErrorField)
        if (element) {
          element.focus()
        }
        return
      }
      
      this.isSubmitting = true
      
      try {
        // Simulate API call
        await new Promise(resolve => setTimeout(resolve, 2000))
        
        // Show success message with form data
        this.showSuccessAlert()
        this.submitted = true
        
      } catch (error) {
        alert('There was an error sending your message. Please try again.')
      } finally {
        this.isSubmitting = false
      }
    },
    
    showSuccessAlert() {
      const formData = {
        'First Name': this.form.firstName,
        'Last Name': this.form.lastName,
        'Email': this.form.email,
        'Telephone': this.form.telephone || 'Not provided',
        'Message': this.form.message
      }
      
      const message = Object.entries(formData)
        .map(([key, value]) => `${key}: ${value}`)
        .join('\n')
      
      alert(`Form submitted successfully!\n\n${message}`)
    },
    
    resetForm() {
      this.form = {
        firstName: '',
        lastName: '',
        email: '',
        telephone: '',
        message: '',
        agreeToTerms: false
      }
      this.errors = {}
      this.submitted = false
    },
    
    setupIntersectionObserver() {
      const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            entry.target.classList.add('animate')
          }
        })
      }, {
        threshold: 0.2
      })

      const animatedElements = this.$el.querySelectorAll('.fade-in, .slide-in-left, .slide-in-right')
      animatedElements.forEach(el => observer.observe(el))
    }
  }
}
</script>

<style lang="scss" scoped>
.contact {
  padding: $spacing-3xl 0;
  background: black;
}

.section-header {
  text-align: center;
  margin-bottom: $spacing-3xl;
}

.section-title {
  font-size: $font-size-4xl;
  font-weight: bold;
  color: white;
  margin-bottom: $spacing-md;

  @media (max-width: $breakpoint-md) {
    font-size: $font-size-3xl;
  }
}

.section-subtitle {
  font-size: $font-size-lg;
  color: rgba(255, 255, 255, 0.8);
  max-width: 600px;
  margin: 0 auto;

  @media (max-width: $breakpoint-md) {
    font-size: $font-size-base;
  }
}

.contact-content {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: $spacing-3xl;
  align-items: stretch; // Make both containers same height

  @media (max-width: $breakpoint-lg) {
    grid-template-columns: 1fr;
    gap: $spacing-2xl;
  }
}

// Contact Form
.contact-form-container {
  opacity: 0;
  transform: translateX(-50px);
  transition: all 1s ease;
  height: 100%; // Match parent container height

  &.animate {
    opacity: 1;
    transform: translateX(0);
  }
}

.contact-form {
  background-color: black;
  width: 100%;           
  height: 100%;          // Full height to match map container
  min-height: 500px;     // Minimum height matching map
  padding: $spacing-2xl;
  border-radius: $border-radius-xl;
  box-shadow: $shadow-lg;
  display: flex;
  flex-direction: column;
  justify-content: space-between; // Distribute content evenly

  @media (max-width: $breakpoint-md) {
    padding: $spacing-xl;
    min-height: 400px; // Match mobile map height
  }

  // Make all text elements visible on black background
  label {
    color: white;
    font-weight: 500;
  }

  input, textarea {
    background-color: rgba(255, 255, 255, 0.1);
    border: 1px solid rgba(255, 255, 255, 0.3);
    color: white;
    padding: 0.75rem;
    border-radius: 6px;

    &::placeholder {
      color: rgba(255, 255, 255, 0.6);
    }

    &:focus {
      border-color: $primary-color;
      background-color: rgba(255, 255, 255, 0.15);
      outline: none;
      box-shadow: 0 0 0 2px rgba(66, 153, 225, 0.3);
    }

    &.error {
      border-color: #ff6b6b;
    }
  }

  .error-message {
    color: #ff6b6b;
    font-size: 0.875rem;
    margin-top: 0.25rem;
  }
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: $spacing-lg;

  @media (max-width: $breakpoint-sm) {
    grid-template-columns: 1fr;
    gap: 0;
  }
}

.form-group {
  margin-bottom: $spacing-lg;

  label {
    display: block;
    margin-bottom: 0.5rem;
    color: white;
    font-weight: 500;
  }

  input, textarea {
    width: 100%;
    background-color: rgba(255, 255, 255, 0.1);
    border: 1px solid rgba(255, 255, 255, 0.3);
    color: white;
    padding: 0.75rem;
    border-radius: 6px;
    font-family: inherit;

    &::placeholder {
      color: rgba(255, 255, 255, 0.6);
    }

    &:focus {
      border-color: $primary-color;
      background-color: rgba(255, 255, 255, 0.15);
      outline: none;
      box-shadow: 0 0 0 2px rgba(66, 153, 225, 0.3);
    }

    &.error {
      border-color: #ff6b6b;
    }
  }

  textarea {
    resize: vertical;
    min-height: 120px;
  }

  .error-message {
    color: #ff6b6b;
    font-size: 0.875rem;
    margin-top: 0.25rem;
    display: block;
  }
}

.form-actions {
  margin-top: $spacing-xl;
  display: flex;
  justify-content: flex-end;
}

.submit-btn {
  min-width: 200px;
  padding: $spacing-md $spacing-xl;
  background-color: #faa70d !important;
  color: black !important;
  border: none;
  border-radius: 6px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;

  &:hover {
    background-color: #ffed4e !important;
    color: black !important;
    transform: translateY(-1px);
  }

  &:disabled {
    background-color: rgba(255, 215, 0, 0.5) !important;
    color: rgba(0, 0, 0, 0.5) !important;
    cursor: not-allowed;
    transform: none;
  }
}

.form-footer {
  margin-top: $spacing-lg;
  margin-bottom: $spacing-lg;
}

.required-note {
  margin-bottom: $spacing-md;
  
  .required-text {
    font-size: $font-size-sm;
    color: rgba(255, 255, 255, 0.7);
    font-style: italic;
  }
}

.terms-group {
  .checkbox-wrapper {
    display: flex;
    align-items: flex-start;
    gap: $spacing-sm;
    margin-bottom: $spacing-xs;
  }

  input[type="checkbox"] {
    margin: 0;
    padding: 0;
    width: 16px;
    height: 16px;
    margin-top: 2px;
    flex-shrink: 0;
    cursor: pointer;
    background-color: rgba(255, 255, 255, 0.1);
    border: 1px solid rgba(255, 255, 255, 0.3);
    border-radius: 3px;
    
    &:checked {
      background-color: $primary-color;
      border-color: $primary-color;
    }
    
    &.error {
      outline: 2px solid #ff6b6b;
      outline-offset: 1px;
    }
  }

  .checkbox-label {
    font-size: $font-size-sm;
    line-height: 1.4;
    color: white;
    cursor: pointer;
    margin: 0;
    
    &:hover {
      color: $primary-color;
    }
  }
}

.submitting {
  display: flex;
  align-items: center;
  gap: $spacing-sm;
}

.spinner {
  width: 16px;
  height: 16px;
  border: 2px solid transparent;
  border-top: 2px solid currentColor;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

// Success Message
.success-message {
  background-color: rgba(255, 255, 255, 0.1);
  padding: $spacing-2xl;
  border-radius: $border-radius-xl;
  box-shadow: $shadow-lg;
  text-align: center;
  border: 2px solid $success-color;

  .success-icon {
    color: $success-color;
    margin-bottom: $spacing-lg;
  }

  h3 {
    color: white;
    margin-bottom: $spacing-md;
    font-size: $font-size-xl;
  }

  p {
    color: rgba(255, 255, 255, 0.8);
    margin-bottom: $spacing-xl;
  }

  .btn {
    background-color: transparent;
    color: white;
    border: 2px solid white;
    
    &:hover {
      background-color: white;
      color: black;
    }
  }
}

// Map Container
.map-container {
  opacity: 0;
  transform: translateX(50px);
  transition: all 1s ease 0.3s;

  &.animate {
    opacity: 1;
    transform: translateX(0);
  }
}

.map-wrapper {
  position: relative;
  height: 500px;
  border-radius: $border-radius-xl;
  overflow: hidden;
  box-shadow: $shadow-lg;

  @media (max-width: $breakpoint-md) {
    height: 400px;
  }
}

.google-map-iframe {
  width: 100%;
  height: 100%;
  border: 0;
  border-radius: $border-radius-lg;
}

.map-overlay {
  position: absolute;
  top: $spacing-lg;
  left: $spacing-lg;
  background-color: rgba(white, 0.95);
  padding: $spacing-lg;
  border-radius: $border-radius-lg;
  box-shadow: $shadow-md;
  backdrop-filter: blur(10px);
  max-width: 280px;

  @media (max-width: $breakpoint-md) {
    position: static;
    max-width: none;
    margin: $spacing-lg;
    background-color: white;
  }
}

.location-info {
  h3 {
    color: $text-dark;
    margin-bottom: $spacing-md;
    font-size: $font-size-lg;
  }
}

.address {
  display: flex;
  gap: $spacing-sm;
  margin-bottom: $spacing-lg;
  
  svg {
    color: $primary-color;
    flex-shrink: 0;
    margin-top: 2px;
  }

  p {
    margin: 0;
    line-height: 1.4;
    font-size: $font-size-sm;
    color: $text-dark;

    &:first-child {
      font-weight: 600;
    }
  }
}

.contact-details {
  display: flex;
  flex-direction: column;
  gap: $spacing-sm;
}

.contact-item {
  display: flex;
  align-items: center;
  gap: $spacing-sm;
  font-size: $font-size-sm;
  color: $text-dark;

  svg {
    color: $primary-color;
    flex-shrink: 0;
  }
}

@media (prefers-reduced-motion: reduce) {
  .contact-form-container,
  .map-container {
    transition: none;
    opacity: 1;
    transform: none;
  }

  .spinner {
    animation: none;
  }
}

// High contrast mode
@media (prefers-contrast: high) {
  .contact-form,
  .success-message,
  .map-overlay {
    border: 2px solid $text-dark;
  }

  .success-message {
    border-color: $success-color;
  }
}

// Focus management
.contact-form {
  input:focus,
  textarea:focus {
    outline: 2px solid $primary-color;
    outline-offset: 2px;
  }
}
</style>
