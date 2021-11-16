<template>
  <section class="container flex flex-col items-center pt-48 gap-y-4">
    <p class="font-serif text-2xl mb-6">Ingresa tu nueva contraseña</p>
    <form
      @submit.prevent="resetPassword"
      class="flex flex-col items-center gap-y-4 w-full"
      id="recovery-form"
    >
      <div class="flex flex-col items-center gap-y-2 w-full">
        <label for="password">Contraseña</label>
        <input
          type="password"
          name="password"
          id="password"
          required
          v-model="$v.password.$model"
          class="text-input text-3xl w-full"
          :class="{ 'input-error': $v.password.$error }"
        />
        <div class="text-sm text-red-500" v-if="!$v.password.minLength">
          La contraseña debe tener un mínimo de
          {{ $v.password.$params.minLength.min }} caracteres.
        </div>
      </div>

      <div class="flex flex-col items-center gap-y-2 w-full">
        <label for="repeat-password">Repetir contraseña</label>
        <input
          type="password"
          name="repeat-password"
          id="repeat-password"
          required
          v-model="repeatedPassword"
          class="text-input text-3xl w-full"
          :class="{ 'input-error': password != repeatedPassword }"
        />
        <div
          class="text-sm text-red-500"
          v-if="password != repeatedPassword"
        >Las contraseñas deben coincidir.</div>
      </div>

      <button class="btn btn-silver">Enviar</button>
    </form>
    <MessageBox :status="recoveryStatus" :message="recoveryMessage" />
  </section>
</template>

<script>
import { required, minLength } from "vuelidate/lib/validators";

export default {
  layout: "no-footer",
  async asyncData({ redirect, $axios, params }) {
    try {
      // Si la request sale bien, no hacemos nada
      // y por lo tanto no va al "catch", donde se redirecciona
      await $axios.$get(`/api/recovery/${params.hash}`);
    } catch (e) {
      return redirect("/");
    }
  },
  data() {
    return {
      password: "",
      repeatedPassword: "",
      recoveryStatus: null,
      recoveryMessage: "",
    };
  },
  validations: {
    password: {
      required,
      minLength: minLength(5),
    },
  },
  methods: {
    async resetPassword() {
      this.$v.$touch();
      if (this.$v.$invalid) {
        this.recoveryStatus = "ERROR";
        this.recoveryMessage = "Corrija el formulario antes de enviarlo.";
        return;
      }

      if (this.password != this.repeatedPassword) return;

      this.recoveryStatus = "PENDING";
      this.recoveryMessage = "Enviando...";

      try {
        await this.$axios.post(`/api/recovery/${this.$route.params.hash}`, {
          password: this.password,
        });

        this.recoveryStatus = "OK";
        this.recoveryMessage = "Contraseña reseteada correctamente.";
      } catch (e) {
        this.recoveryStatus = "ERROR";

        if (e.response.data.errors) {
          this.registerMessage = e.response.data.errors[0].msg;
        }

        this.recoveryMessage = e.response.data.message;
      }
    },
  },
};
</script>

<style>
</style>
