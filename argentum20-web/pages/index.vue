<template>
  <main>
    <header class="py-48 relative overflow-hidden">
      <!-- <img
        src="@/assets/img/game.png"
        alt="Argentum 20"
        class="absolute top-0 left-0 w-full h-full object-cover"
        style="filter: brightness(0.4); z-index: -1;"
      />-->
      <div class="container flex justify-center items-center">
        <div class="flex flex-col items-center">
          <img src="@/assets/img/argentum20_logo.png" alt="Argentum 20 Logo" class="mb-6" />
          <h1 class="text-3xl text-gr gr-gold">El Servidor Oficial de AO Clásico</h1>
        </div>
      </div>
    </header>
    <section class="bg-gray-1000 py-6 border-t border-b border-gr border-gr-silver mb-40">
      <div class="container flex justify-center items-center gap-x-8">
        <h3 class="font-sans font-normal text-lg">Seguinos</h3>
        <div class="flex items-center gap-x-4 text-3xl">
          <a
            href="#"
            target="_blank"
            class="transition-colors duration-150 ease-out hover:text-gold"
          >
            <i class="fab fa-discord"></i>
          </a>
          <a
            href="#"
            target="_blank"
            class="transition-colors duration-150 ease-out hover:text-gold"
          >
            <i class="fab fa-youtube"></i>
          </a>
          <a
            href="#"
            target="_blank"
            class="transition-colors duration-150 ease-out hover:text-gold"
          >
            <i class="fab fa-instagram"></i>
          </a>
          <a
            href="#"
            target="_blank"
            class="transition-colors duration-150 ease-out hover:text-gold"
          >
            <i class="fal fa-envelope"></i>
          </a>
        </div>
      </div>
    </section>
    <div class="container flex justify-center mb-24">
      <div class="flex flex-col items-center">
        <div class="relative mb-2 z-10">
          <a
            id="download-btn"
            href="#"
            class="inline-block text-2xl font-serif font-bold tracking-wider uppercase px-5 py-3 border-2 border-gr border-gr-gold bg-gradient-to-t from-gray-900 to-gray-800 hover:from-gray-700"
          >Descargar el Instalador</a>
        </div>
        <!-- <img src="@/assets/img/wings.png" alt class="absolute top-0 inset-x-auto" /> -->
        <p class="text-sm text-gray-600">Sólo disponible para Windows</p>
      </div>
    </div>
    <section class="container grid grid-cols-2 gap-8">
      <RegisterForm />
      <figure>
        <img
          src="@/assets/img/gulfas.png"
          alt="Estatua de Gulfas Morgolock"
          class="w-full border border-gr border-gr-silver mb-4"
        />
        <figcaption class="text-right italic text-lg">
          <q
            class="block mb-3"
          >Se me ocurrió que acá haya una frase épica relacionada a Argentum, quizá algo que indique el renacimiento del servidor oficial.</q>
          <p>— Gulfas Morgolock</p>
        </figcaption>
      </figure>
    </section>
    <!-- <div v-if="validatedMail" class="py-4 bg-green-200 text-green-700">
      <div class="container">
        <p>Se ha validado el mail correctamente</p>
      </div>
    </div>-->
  </main>
</template>

<script>
function sleep(ms, value) {
  return new Promise((resolve) => setTimeout(resolve, ms, value));
}

export default {
  data() {
    return {
      validatedMail: false,
      resendEmailTime: 60,
    };
  },
  mounted() {
    const validatedMailParam = this.$route.query.validated;

    if (validatedMailParam == "true") {
      this.validatedMail = true;

      setTimeout(() => {
        this.validatedMail = false;
      }, 3000);
    }
  },
};
</script>

<style>
header {
  background-image: url("/assets/img/game.png");
  @apply bg-cover bg-center;
}

#download-btn {
  transition: all 150ms ease-out;
  box-shadow: 0 0 20px rgba(199, 131, 0, 0.4);
}

#download-btn::before {
  @apply absolute top-0;
  content: url("/assets/img/wings.png");
  left: 50%;
  transform: translateY(-99px) translateX(-50%);
  z-index: -1;
}

#download-btn:hover {
  box-shadow: 0 0 40px rgba(199, 131, 0, 0.7), inset 0 0 35px -10px rgba(0, 0, 0, 0.75);
}

/* #download-btn:active {
  box-shadow: inset 0 0;
} */
</style>
