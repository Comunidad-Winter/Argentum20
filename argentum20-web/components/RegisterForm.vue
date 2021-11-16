<template>
  <form @submit.prevent="registerAccount" class="flex flex-col gap-y-4">
    <h3 class="text-2xl text-gr gr-gold mb-4">¡Creá tu cuenta!</h3>

    <div class="grid grid-cols-2 gap-8 mb-4">
      <div class="flex flex-col gap-y-2">
        <label for="name">Nombre de cuenta</label>
        <input
          type="text"
          name="name"
          id="name"
          required
          v-model="$v.name.$model"
          class="text-input"
          :class="{ 'input-error': $v.name.$error }"
        />
        <div class="text-sm text-red-500">
          <p
            v-if="!$v.name.minLength"
          >El nombre debe tener un mínimo de {{ $v.name.$params.minLength.min }} caracteres.</p>
          <p
            v-if="!$v.name.maxLength"
          >El nombre debe tener un máximo de {{ $v.name.$params.maxLength.max }} caracteres.</p>
          <p v-if="!$v.name.alphaNumWithSpaces">El nombre sólo puede contener letras y números.</p>
          <p
            v-if="!$v.name.noBeginningOrEndSpaces"
          >El nombre no puede tener espacios al comienzo o al final.</p>
        </div>
      </div>

      <div class="flex flex-col gap-y-2">
        <label for="email">Correo electrónico</label>
        <input
          type="email"
          name="email"
          id="email"
          required
          v-model="$v.email.$model"
          class="text-input"
          :class="{ 'input-error': $v.email.$error }"
        />
        <div class="text-sm text-red-500" v-if="$v.email.$error">Ingrese un email válido.</div>
      </div>

      <div class="flex flex-col gap-y-2">
        <label for="password">Contraseña</label>
        <input
          type="password"
          name="password"
          id="password"
          required
          v-model="$v.password.$model"
          class="text-input"
          :class="{ 'input-error': $v.password.$error }"
        />
        <div class="text-sm text-red-500" v-if="!$v.password.minLength">
          La contraseña debe tener un mínimo de
          {{ $v.password.$params.minLength.min }} caracteres.
        </div>
      </div>

      <div class="flex flex-col gap-y-2">
        <label for="repeat-password">Repetir contraseña</label>
        <input
          type="password"
          name="repeat-password"
          id="repeat-password"
          required
          v-model="repeatedPassword"
          class="text-input"
          :class="{ 'input-error': password != repeatedPassword }"
        />
        <div
          class="text-sm text-red-500"
          v-if="password != repeatedPassword"
        >Las contraseñas deben coincidir.</div>
      </div>
    </div>

    <div class="flex justify-between items-start">
      <button class="btn btn-silver self-start" :disabled="registerStatus == 'PENDING'">Crear cuenta</button>
      <NuxtLink
        to="/recuperar"
        class="text-gray-400 hover:text-gray-500 underline text-sm"
      >¿Olvidaste tu contraseña?</NuxtLink>
    </div>
    <!-- <Btn :disabled="registerStatus == 'PENDING'" class="self-start">Crear Cuenta</Btn> -->

    <MessageBox :status="registerStatus" :message="registerMessage" />
  </form>
</template>

<script>
import { required, minLength, maxLength, email, alphaNum, helpers } from "vuelidate/lib/validators";

function sleep(ms, value) {
  return new Promise((resolve) => setTimeout(resolve, ms, value));
}

const alphaNumWithSpaces = (value) => !helpers.req(value) || /^[a-z0-9 ]+$/i.test(value);
const noBeginningOrEndSpaces = (value) => !helpers.req(value) || value == value.trim();

export default {
  data() {
    return {
      name: "",
      password: "",
      repeatedPassword: "",
      email: "",
      auxEmail: "",
      registerStatus: null,
      registerMessage: "",
      validatedMail: false,
      resendEmailTime: 60,
    };
  },
  validations: {
    name: {
      required,
      alphaNumWithSpaces,
      noBeginningOrEndSpaces,
      minLength: minLength(3),
      maxLength: maxLength(40),
    },
    password: {
      required,
      minLength: minLength(5),
    },
    email: {
      required,
      email,
    },
  },
  methods: {
    async registerAccount() {
      this.registerStatus = "PENDING";
      this.registerMessage = "Creando tu cuenta...";

      const { name, password, repeatedPassword, email } = this;

      try {
        // await sleep(750);

        await this.$axios.post("/api/accounts", {
          name,
          password,
          repeatedPassword,
          email,
        });

        this.registerStatus = "OK";
        this.registerMessage = `¡Éxito! Te enviamos un correo a <strong>${email}</strong> para que valides tu cuenta.`;

        setInterval(() => {
          this.resendEmailTime -= 1;
        }, 1000);
      } catch (e) {
        this.registerStatus = "ERROR";

        if (e.response) {
          const data = e.response.data;

          if (data.error == "account_exists") {
            // TODO: Poner olvidaste contraseña o reenviar código de activación
            this.registerMessage = "Esa cuenta ya existe.";
          } else if (data.error == "email_exists") {
            // TODO: Poner olvidaste contraseña o reenviar código de activación
            this.registerMessage = "Ya existe una cuenta con ese email.";
          } else if (data.error == "internal_error") {
            this.registerMessage =
              "Hubo un error desconocido. Por favor, contactanos por otro medio para pedir asistencia. ¡Respondemos rápido!";
          }

          if (data.errors) {
            this.registerMessage = data.errors[0].msg;
          }
        }
      }
    },
  },
};
</script>

<style>
</style>
