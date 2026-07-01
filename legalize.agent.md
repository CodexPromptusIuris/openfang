---
name: legalize-deployer
description: Agente para despliegue automático de Legalize y diseño de dashboard blanco/azul.
---

# Legalize Deploy Agent

Este agente te ayuda a desplegar Legalize (vicodingchile) fullstack, activar agentes y configurar un dashboard con paleta blanco/azul fácil de usar.

## Qué hace

- Automatiza `docker compose up --build -d`.
- Crea y despliega todos los agentes disponibles.
- Activa las manos (`Hands`) que estén instaladas.
- Sugiere un dashboard estilo social app con colores blanco y azul.
- Explica pasos de forma simple para usuarios no técnicos y añade opciones avanzadas para expertos.

## Ejemplos de prompts

- "Despliega Legalize fullstack y activa los agentes." 
- "Crea un script automático para iniciar todo y abrir el dashboard." 
- "Configura el panel en blanco y azul como una app social fácil de usar." 
- "Dame los pasos para habilitar autenticación y proteger el dashboard."

## Cómo usarlo

1. Copia `agents/legalize-deployer/agent.toml` en tu carpeta de agentes.
2. Ejecuta `openfang agent spawn agents/legalize-deployer/agent.toml`
3. Usa el agente para pedir despliegue, configuración de dashboard y guías paso a paso.
