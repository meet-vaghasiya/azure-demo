// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2025-07-15',
  devtools: { enabled: true },
  
  // SSR enabled by default in Nuxt 4
  ssr: true,
  
  // Azure App Service configuration
  nitro: {
    preset: 'azure',
    azure: {
      config: {
        platform: {
          apiRuntime: 'node:20'
        }
      }
    }
  },
  
  // Runtime config for environment variables
  runtimeConfig: {
    public: {
      apiBase: process.env.NUXT_PUBLIC_API_BASE || '/api',
      environment: process.env.NUXT_PUBLIC_ENVIRONMENT || 'development'
    }
  }
})
