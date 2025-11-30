#!/bin/bash

npm create fuwari@latest

(cd web && pnpm add -D @iconify-json/fa6-brands)
(cd web && pnpm add -D @iconify-json/vaadin)

(cd web && pnpm run dev)

