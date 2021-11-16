<template>
  <section class="container flex flex-col items-center pt-48 gap-y-4">
    <p class="font-serif text-2xl mb-6">Te enviaremos un mail para que recuperes tu contraseña</p>
    <form
      @submit.prevent="sendRecovery"
      class="flex flex-col items-center gap-y-4 w-full"
      id="recovery-form"
    >
      <div class="flex flex-col items-center gap-y-2 w-full">
        <label for="email">Email asociado a la cuenta</label>
        <input
          type="email"
          name="email"
          id="email"
          required
          v-model="$v.email.$model"
          class="text-input text-3xl w-full"
          :class="{ 'input-error': $v.email.$error }"
        />
        <div class="text-sm text-red-500" v-if="$v.email.$error">Ingrese un email válido.</div>
      </div>
      <button class="btn btn-silver">Enviar</button>
      <MessageBox :status="recoveryStatus" :message="recoveryMessage" />
    </form>
  </section>
</template>

<script>
import { required, email } from "vuelidate/lib/validators";

export default {
  layout: "no-footer",
  data() {
    return {
      email: "",
      recoveryStatus: null,
      recoveryMessage: "",
    };
  },
  validations: {
    email: {
      required,
      email,
    },
  },
  methods: {
    async sendRecovery() {
      this.$v.$touch();
      if (this.$v.$invalid) {
        this.recoveryStatus = "ERROR";
        this.recoveryMessage = "Corrija el formulario antes de enviarlo.";
        return;
      }
      this.recoveryStatus = "PENDING";
      this.recoveryMessage = "Enviando...";

      try {
        await this.$axios.post("/api/recovery", {
          email: this.email,
        });

        this.recoveryStatus = "OK";
        this.recoveryMessage = "¡Listo! Revisá tu bandeja de entrada.";
      } catch (e) {
        this.recoveryStatus = "ERROR";
        this.recoveryMessage = e.response.data.message;
      }
    },
  },
};
</script>

<style>
</style>
