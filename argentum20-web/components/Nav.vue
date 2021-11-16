<template>
  <nav class="w-full fixed z-50" style="top: 1rem;">
    <div class="container flex items-center gap-x-3">
      <NuxtLink to="/" class="w-24 flex-grow-0">
        <img src="@/assets/img/logo_square.png" alt="Logo Argentum 20 cuadrado" />
      </NuxtLink>
      <div class="bg-gray-900 py-4 px-8 flex w-full justify-between items-center hidden">
        <ul>
          <li>
            <NuxtLink to="/">Staff</NuxtLink>
          </li>
        </ul>
        <i class="fab fa-facebook text-2xl"></i>
      </div>
    </div>
  </nav>
</template>

<script>
export default {};
</script>

<style>
</style>
