<template>
  <div class="container pt-40">
    <div class="grid grid-cols-3 gap-12">
      <article
        v-for="item in items"
        :key="item.id"
        class="bg-gray-1000 border border-gr border-gr-silver p-8"
      >
        <h2>{{ item.name }}</h2>
        <p class="text-2xl mb-4">${{ item.price }}</p>
        <button @click="getPreference(item.id)" class="btn btn-silver">Comprar</button>
      </article>
    </div>
  </div>
</template>

<script>
export default {
  async fetch() {
    const items = await this.$axios.$get("api/premium/items");
    this.items = items;
  },
  data() {
    return {
      items: [],
      init_point: "",
    };
  },
  methods: {
    async getPreference(itemId) {
      const preference = await this.$axios.$get(`api/premium/preference/${itemId}`);
      window.open(preference.sandbox_init_point, "_parent");
    },
  },
};
</script>

<style></style>
