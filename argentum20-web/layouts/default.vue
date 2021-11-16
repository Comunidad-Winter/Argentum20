<template>
  <div class="min-h-screen" style="background: url('/assets/img/bg_texture.png') repeat">
    <Nav />
    <Nuxt />
    <Footer />
  </div>
</template>

<style>
:root {
  --gold: #c78300;
  --silver: #d3d3d3;
}

* {
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

body {
  @apply text-white;
  background: url("/assets/img/bg_texture.png") repeat;
}

.text-gr {
  @apply bg-clip-text text-transparent bg-gradient-to-t;
}

.border-gr {
  border-image-slice: 1;
}

.gr-gold {
  @apply from-gold to-white;
}

.gr-silver {
  @apply from-silver to-white;
}

.border-gr-silver {
  border-image-source: linear-gradient(to right, #666, #fff, #666);
}

.border-gr-gold {
  border-image-source: linear-gradient(to right, #8c5d00, #ffbe15, #8c5d00);
}

.text-input {
  @apply py-2 px-3 border border-gr border-gr-silver;
  background-color: #392919;
  box-shadow: inset 0 0 15px 0 rgba(0, 0, 0, 0.75);
}

.text-input:focus {
  @apply border-gr-gold outline-none;
}

.text-input.input-error {
  border-image-slice: intial;
  border-image-source: initial;
  @apply border-red-500;
}

.text-input.input-error:focus {
  @apply border-red-500;
}

.btn {
  @apply transition duration-150 ease-out font-serif font-bold uppercase tracking-wide py-3 px-4 border;
}

.btn:hover {
  box-shadow: inset 0 0 30px rgba(255, 255, 255, 0.2);
}

.btn:focus {
  @apply outline-none;
  box-shadow: inset 0 0 20px rgba(255, 190, 21, 0.2);
}

.btn-silver {
  @apply bg-gray-900 text-white border-gr border-gr-silver;
}

.btn-silver:focus {
  @apply border-gr-gold;
}

.btn-silver:disabled {
  @apply text-gray-700 border-gray-700;
}

@screen sm {
  #recovery-form {
    max-width: 640px;
  }
}

.lds-dual-ring {
  display: inline-block;
  width: 24px;
  height: 24px;
}
.lds-dual-ring:after {
  content: " ";
  display: block;
  width: 24px;
  height: 24px;
  border-radius: 50%;
  border: 6px solid #2b6cb0;
  border-color: #2b6cb0 transparent #2b6cb0 transparent;
  animation: lds-dual-ring 1.2s linear infinite;
}
@keyframes lds-dual-ring {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}
</style>
