# No-Code / Low-Code AI Agent Builder Platforms — Established Players

Research date: 2026-02-27

This document surveys purpose-built platforms for non-technical (or semi-technical) users to create multi-step AI agent workflows. It covers positioning, capabilities, pricing, maturity, adoption, and limitations.

---

## Platform Summaries

### 1. Relevance AI

**What it is:** No-code platform for building teams of AI agents, with emphasis on data handling and vector search.

**Target audience:** Operations, marketing, and revenue teams. Genuinely accessible to non-technical users — the "Invent" feature generates agent drafts from plain English descriptions.

**Key capabilities:**
- Multi-step agent workflows with LLM prompts, API calls, custom code, and pre-built integrations
- Vector search / RAG over company data
- Multi-model support
- Agent templates and an "AI workforce" framing (multiple agents collaborating)

**Pricing:** Freemium. Free tier available; paid plans start at $19/month (Pro, Team tiers with more actions and vendor credits).

**Maturity:**
- Founded: 2020 (Sydney & San Francisco)
- Total funding: $37M across 3 rounds (Series B of $24M in May 2025, led by Bessemer Venture Partners with Insight Partners, Peak XV)
- Team: ~80 employees
- [Source: TechCrunch](https://techcrunch.com/2025/05/06/relevance-ai-raises-24m-series-b-to-help-anyone-build-teams-of-ai-agents/)

**Adoption signals:**
- G2: 4.5/5 (1,783 reviews) — strong signal
- Product Hunt: 4.8/5 (54 reviews)
- 40,000 AI agents registered in January 2025 alone
- [Source: G2](https://www.g2.com/products/relevance-ai/reviews)

**Limitations:**
- Steep learning curve for complex, multi-step workflows despite the no-code surface
- Some users report limitations handling sophisticated branching logic
- [Source: Salesforge overview](https://www.salesforge.ai/directory/sales-tools/relevance-ai)

---

### 2. Stack AI

**What it is:** Enterprise-grade no-code platform for building and deploying secure AI agents, focused on regulated industries.

**Target audience:** IT teams and operations leaders in finance, healthcare, insurance, manufacturing, public sector. More enterprise-oriented than most competitors.

**Key capabilities:**
- Visual drag-and-drop workflow builder
- Extensive integrations: Notion, Airtable, AWS, every major LLM, BigQuery, GitHub, Google Workspace, HubSpot, MCP, MongoDB
- SOC 2 Type II, HIPAA, GDPR compliant; ISO 27001 in progress
- RBAC, SSO, audit logs, version control

**Pricing:** Free plan ($0, 500 runs/month, 2 projects, 1 seat). Starter: $199/month (2,000 runs, 5 projects, 2 seats). Enterprise pricing available.

**Maturity:**
- Founded: ~2022 (YC-backed)
- Total funding: ~$19.6M (Series A of $16M, investors include Lobby VC, LifeX Ventures, Guillermo Rauch, Bob Van Luijt)
- [Source: Stack AI blog](https://www.stack-ai.com/blog/stack-ai-raises-16m-series-a-to-create-ai-agents-for-every-job)

**Adoption signals:**
- G2: 38 reviews (positive but limited volume)
- Positioned strongly for enterprise compliance needs
- [Source: G2](https://www.g2.com/products/stackai/reviews)

**Limitations:**
- Performance can be inconsistent at times
- Learning curve for advanced use cases
- Documentation could be clearer for new users
- Pricing higher than most competitors at the starter tier
- [Source: Marketer Milk review](https://www.marketermilk.com/blog/stack-ai-review)

---

### 3. Wordware

**What it is:** Web-hosted IDE for LLM orchestration using natural-language-like programming (English with loops, logic, function calling).

**Target audience:** Originally cross-functional teams building AI apps; now pivoting away from the workflow builder.

**Key capabilities:**
- English-like workflow definition with programming concepts (loops, conditionals, function calls)
- One-click deployment
- Multi-model support

**Pricing:** Previously available; current status unclear due to pivot.

**Maturity:**
- YC-backed; raised $30M seed (biggest in YC history at the time), led by Spark Capital and Felicis
- Launched #1 on Product Hunt all-time
- Notable users included Instacart, Runway, Glassdoor
- [Source: VentureBeat](https://venturebeat.com/ai/how-wordware-30m-seed-round-could-disrupt-the-entire-ai-development-industry)

**Current status: PIVOTING.** The company is transitioning from the Wordware workflow builder to "Sauna," an AI companion/workspace for knowledge workers (described as "Cursor for Knowledge Work"). The existing Wordware v1 product appears to be maintained but is no longer the primary focus. Sauna is in waitlist phase as of early 2026.

**Assessment:** Not recommended for new adoption as a workflow builder — the team's energy and roadmap are moving elsewhere.

- [Source: Wordware announcement](https://www.wordware.ai/announcement)
- [Source: Sauna](https://www.sauna.ai/)

---

### 4. Cassidy AI

**What it is:** No-code AI automation platform that lets teams build agents and workflows connected to internal company data.

**Target audience:** Non-technical business teams — explicitly targets users who can "stand up Workflows and Agents in hours, not months."

**Key capabilities:**
- Drag-and-drop workflow builder with Workflow Copilot (builds logic from plain language)
- 100+ integrations (SharePoint, Slack, Drive, etc.)
- Contextual AI assistants, automated RFP responses, lead enrichment, internal search, ticket triage
- Enterprise-grade encryption

**Pricing:** 14-day free trial. Pro tier starts at $79/user/month.

**Maturity:**
- Founded: 2023
- Total funding: $13.7M ($3.7M seed + $10M Series A led by HOF Capital)
- Team: ~38 employees
- Founders: Ian Woodfill and Justin Fineberg (CEO)
- [Source: Cassidy blog](https://www.cassidyai.com/blog/announcing-cassidys-10m-series-a)

**Adoption signals:**
- 20,000+ teams using the platform
- 4.8M workflow automations in the last quarter (as of Series A announcement)
- Average enterprise sees 3x adoption expansion and 12x usage increase in first 6 months
- [Source: PRNewswire](https://www.prnewswire.com/news-releases/cassidy-raises-10m-series-a-as-organizations-adopt-context-powered-automation-to-accelerate-enterprise-ai-impact-and-transformation-302549537.html)

**Limitations:**
- Per-user pricing ($79/user) is expensive for larger teams
- Relatively young platform (founded 2023)
- Smaller integration library than some competitors

---

### 5. Flowise

**What it is:** Open-source, low-code platform for building AI agents and LLM workflows visually, built on top of LangChain.

**Target audience:** Developers and technical teams who want visual prototyping with full infrastructure control. Not truly no-code — requires understanding of LLM concepts.

**Key capabilities:**
- Three workflow types: Assistant (beginner-friendly), Chatflow (single-agent), Agentflow (multi-agent orchestration)
- RAG, Graph RAG, reranker support
- Human-in-the-loop checkpoints
- Observability (Prometheus, OpenTelemetry)
- Self-hosted or cloud-hosted

**Pricing:**
- Self-hosted: Free (open-source)
- Cloud: Free tier (2 flows, 100 predictions/month) -> Starter $35/month (unlimited flows, 10K predictions) -> Enterprise (custom)

**Maturity:**
- Co-founded by Henry Heng (CEO) and Chung Yau Ong; YC-backed
- **Acquired by Workday in August 2025** — provides strong financial backing but may shift product direction toward HR/finance use cases
- 49.2K GitHub stars
- [Source: Workday newsroom](https://newsroom.workday.com/2025-08-14-Workday-Acquires-Flowise,-Bringing-Powerful-AI-Agent-Builder-Capabilities-to-the-Workday-Platform)

**Adoption signals:**
- Millions of chats and workflows processed
- Strong open-source community (49K+ GitHub stars)
- Cross-industry adoption
- [Source: GitHub](https://github.com/FlowiseAI/Flowise)

**Limitations:**
- Requires understanding of LLM concepts (vector stores, embeddings, chunking) — not truly accessible to non-technical users
- Self-hosting requires infrastructure management
- Workday acquisition may narrow focus over time
- Enterprise features still maturing
- [Source: Sider AI review](https://sider.ai/blog/ai-tools/flowise-ai-review-is-this-the-best-open-source-llm-builder-in-2025)

---

### 6. Langflow

**What it is:** Open-source, low-code visual environment for building AI agents and RAG applications, with a drag-and-drop interface.

**Target audience:** Developers and technical builders. Despite the visual interface, it "requires deep technical knowledge to build basic AI agents."

**Key capabilities:**
- Visual drag-and-drop flow builder
- Multi-agent support
- Python-based customization for advanced use cases
- Cloud (via DataStax) or self-hosted

**Pricing:** Open-source core is free. Cloud pricing via DataStax Langflow (specific tiers not publicly detailed).

**Maturity:**
- **Acquired by DataStax in April 2024**, which was subsequently **acquired by IBM** (folding into watsonx)
- Langflow promises to remain "open, free, and agnostic"
- [Source: TechCrunch](https://techcrunch.com/2024/04/04/datastax-acquires-logspace-the-startup-behind-the-langflow-low-code-tool-for-building-rag-based-chatbots/)

**Adoption signals:**
- Strong developer community
- 5.0/5 rating from 1,000+ reviews (per multiple review aggregators)
- Backed by IBM/DataStax resources
- [Source: Langflow blog](https://www.langflow.org/blog/big-news-for-langflow)

**Limitations:**
- Not suitable for non-technical users — requires API knowledge, data transformation skills
- Lacks advanced scheduling, retries, and observability that production tools like Airflow/n8n handle better
- System instability reported by some users
- Not fully optimized for production-level applications
- [Source: Lindy alternatives post](https://www.lindy.ai/blog/langflow-alternatives)

---

### 7. Dust.tt

**What it is:** AI agent platform for building "company-grade" assistants with secure access to internal knowledge and tools.

**Target audience:** Knowledge workers and teams at fast-growing companies. Designed for business users who need context-aware agents, not developers.

**Key capabilities:**
- Custom agents connected to Notion, Slack, GitHub, Google Workspace, external websites
- Agent chaining (specialized agents collaborate on tasks)
- Agent Memory (per-user, per-agent persistent memory)
- Frames (interactive dashboards/visualizations created by agents)
- Synthetic filesystem across data sources (Unix-like navigation of company knowledge)
- MCP support

**Pricing:** Pro: EUR 29/user/month. Includes advanced models, custom agents, unlimited messages (fair-use), up to 1GB/user data sources.

**Maturity:**
- Founded by Stanislas Polu and Gabriel Hubert (CEO)
- Total funding: $21.5M (EUR 5M seed from Sequoia + $16M Series A in June 2024)
- Team: 66 employees
- Revenue: $7.3M ARR (mid-2025)
- [Source: Getlatka](https://getlatka.com/companies/dust.tt)

**Adoption signals:**
- G2: 4.9/5 (19 reviews) — small sample but very high
- One company configured 7,683 agents in 2025
- 80,000 agents created, 12M conversations (2025 wrapped stats)
- SOC2 Type II, GDPR, zero data retention at model providers
- [Source: Dust blog](https://dust.tt/blog/dust-wrapped-2025)

**Limitations:**
- Relatively small team (66) for the ambition
- EUR 29/user/month adds up for large organizations
- Smaller integration library than platforms like Lindy or Zapier
- Less mature than larger competitors

---

### 8. Voiceflow

**What it is:** No-code platform for designing, building, and launching conversational AI agents (chat and voice).

**Target audience:** Product teams, CX teams, and designers building customer-facing conversational experiences. Accessible to non-technical users.

**Key capabilities:**
- Drag-and-drop conversation flow builder
- Agent Step feature (2025) — autonomous AI agents that make dynamic decisions vs. scripted paths
- Voice and chat deployment
- Multichannel: web, mobile, voice assistants
- Collaboration tools for teams

**Pricing:** Free plan available. Paid plans from $60/month. Credit-based system (1 credit per text message, 10 credits per voice minute).

**Maturity:**
- Founded: 2019
- Total funding: $39.8M (most recent: $15M in April 2023, led by OpenView)
- Valuation: ~$105M (2023)
- Team: ~90 employees
- Revenue: $9.9M (mid-2025)
- [Source: Getlatka](https://getlatka.com/companies/voiceflow.com)

**Adoption signals:**
- 500,000+ teams globally
- G2: strong reviews, ease of use most-cited positive (80+ mentions)
- Established player in conversational AI space
- [Source: Voiceflow](https://www.voiceflow.com)

**Limitations:**
- No built-in live chat or direct handoff to human agents
- Analytics are minimal
- Testing capabilities are limited
- Credit-based pricing can be unpredictable
- Enterprise/regulated industry support is weak compared to Stack AI or Botpress
- [Source: GPTBots review](https://www.gptbots.ai/blog/voiceflow-ai-review)

---

### 9. Botpress

**What it is:** Open-source conversational AI platform for building and deploying chatbots and AI agents, evolved from a chatbot builder into a full-stack agent development platform.

**Target audience:** Developers and technical teams building custom conversational agents. Despite improvements, "overwhelms non-technical teams."

**Key capabilities:**
- Visual drag-and-drop flow builder
- Multichannel deployment (web, WhatsApp, Messenger, Slack, custom)
- Enterprise NLU/NLP with multilingual support
- RAG support
- GDPR and SOC 2 compliant
- Open-source core with cloud offering

**Pricing:** Free pay-as-you-go plan (500 messages/month). Plus: $89/month. Team: $495/month. Plus LLM usage costs.

**Maturity:**
- Founded: 2017 (Quebec, Canada) — one of the oldest in this space
- Total funding: ~$45M ($25M Series B in 2025, led by FRAMEWORK with HubSpot Ventures, Deloitte Ventures)
- Team: ~65 employees (planning to double)
- Revenue: $4.4M (2024)
- [Source: Botpress blog](https://botpress.com/blog/series-b)

**Adoption signals:**
- 500,000+ users, 100,000+ AI agents in production
- G2: 4.5/5 (419 reviews)
- Thousands of paying clients, sales doubling quarterly in 2024
- [Source: G2](https://www.g2.com/products/botpress/reviews)

**Limitations:**
- Complexity — steep learning curve, especially for non-technical users
- White-labeling, global compliance, and live support features are missing or require heavy effort
- Pricing is complex and variable (LLM tokens + message volumes + channel mix)
- More developer-oriented than business-user-oriented
- [Source: SiteGPT review](https://sitegpt.ai/blog/botpress-ai-review)

---

### 10. Gumloop

**What it is:** AI-native no-code automation platform with a drag-and-drop builder, focused on AI-first workflows.

**Target audience:** SMBs and non-technical team members in Sales, Marketing, and Operations. Built from the ground up with AI as the core (vs. legacy tools that bolted on AI).

**Key capabilities:**
- Drag-and-drop visual builder
- Web scraping and document processing (PDFs, etc.)
- Integrations with Google Sheets, Slack, OpenAI, and more
- AI Agent tools for autonomous task completion

**Pricing:** Basic: $32/month (annual billing). Credit-based — costs vary by operation complexity (simple AI call = 2 credits, GPT-4 call = up to 60 credits).

**Maturity:**
- Founded: 2023 by Max Brodeur-Urbas (ex-Microsoft) and Rahul Behal (ex-AWS)
- YC-backed
- Total funding: $28.9M ($3.1M seed in July 2024 + $24.6M Series A in Jan 2025, led by Nexus Venture Partners)
- Team: Extremely lean — 2 founders + 1 employee at Series A, aspiring to be a "10-person billion-dollar company"
- [Source: TechCrunch](https://techcrunch.com/2025/01/10/gumloop-founded-in-a-bedroom-in-vancouver-lets-users-automate-tasks-with-drag-and-drop-modules/)

**Adoption signals:**
- Used by Instacart, Webflow, Shopify
- CEO of Instacart publicly endorsed it
- High positive sentiment on G2 and Capterra
- [Source: BetaKit](https://betakit.com/work-automation-platform-gumloop-raises-24-5-million-series-a-as-it-relocates-to-silicon-valley/)

**Limitations:**
- Credit-based pricing is hard to predict until you've used the platform for a while
- Complex workflows have a learning curve
- Very small team — bus factor risk
- Relatively young platform
- [Source: Cybernews review](https://cybernews.com/ai-tools/gumloop-ai-review/)

---

### 11. Lindy AI

**What it is:** No-code platform for creating AI agents that automate knowledge work, using LLMs to understand context and make decisions.

**Target audience:** Business teams (non-technical) automating knowledge work — email triage, lead qualification, content moderation, research.

**Key capabilities:**
- Agent Builder (natural language), Lindy Build (app development with automated testing), Computer Use (web automation beyond APIs)
- 5,000+ integrations
- Multiple AI models: Claude Sonnet 4.5, GPT-5, Gemini Flash 2.0, etc.
- Human-in-the-loop approvals
- SOC 2, HIPAA, GDPR compliant

**Pricing:** Credit-based. Free ($0, 400 credits). Pro: $49.99/month (5,000+ credits). Business: $299.99/month (30,000+ credits).

**Maturity:**
- Total funding: $49.9M (including $35M Series B)
- Revenue: $5.1M (October 2024)
- [Source: Clay dossier](https://www.clay.com/dossier/lindy-funding)

**Adoption signals:**
- Strong blog/content marketing presence
- Frequently cited in comparison articles as a top pick
- [Source: Nocode MBA review](https://www.nocode.mba/articles/lindy-ai-review)

**Limitations:**
- AI reasoning introduces unpredictability — agents may handle edge cases in unexpected ways
- Credit system requires careful monitoring
- Less established than Zapier/Make for pure automation
- [Source: Substack honest review](https://annikahelendi.substack.com/p/my-honest-lindy-ai-review-what-works)

---

### 12. Respell (SHUTTING DOWN)

**What it is:** No-code AI workflow platform for building "Spells" (automated workflows) via drag-and-drop.

**Target audience:** Non-technical users in sales, marketing, and operations.

**Key capabilities:**
- Multi-model support (OpenAI, Anthropic, Cohere, Azure)
- SOC II compliance, data encryption, OAuth, prompt injection prevention
- Lead scoring, content generation, CRM automation

**Pricing:** Starter $19.99/month (was).

**Current status: SHUTTING DOWN.** The Respell team is joining the Agentforce team at Salesforce, and Respell is shutting down as a standalone product on March 1, 2026.

**Assessment:** Not recommended for new adoption.

- [Source: Respell](https://respell.ai/)

---

## Comparison Matrix

| Platform | True No-Code? | Multi-Step Agents | RAG | Human-in-Loop | Pricing (starts) | Funding | G2 Rating |
|---|---|---|---|---|---|---|---|
| Relevance AI | Yes | Yes | Yes | Yes | $19/mo | $37M | 4.5 (1,783) |
| Stack AI | Mostly | Yes | Yes | Yes | $199/mo | $19.6M | ~4.5 (38) |
| Cassidy AI | Yes | Yes | Yes | Yes | $79/user/mo | $13.7M | N/A |
| Dust.tt | Yes | Yes (chaining) | Yes | Partial | EUR 29/user/mo | $21.5M | 4.9 (19) |
| Lindy AI | Yes | Yes | Yes | Yes | $49.99/mo | $49.9M | N/A |
| Gumloop | Mostly | Yes | Partial | No | $32/mo | $28.9M | N/A |
| Voiceflow | Yes | Yes (2025+) | Yes | Partial | $60/mo | $39.8M | ~4.5 |
| Botpress | No (low-code) | Yes | Yes | Yes | $89/mo | $45M | 4.5 (419) |
| Flowise | No (low-code) | Yes | Yes | Yes | Free (self-host) | Acquired (Workday) | N/A |
| Langflow | No (low-code) | Yes | Yes | Partial | Free (self-host) | Acquired (DataStax/IBM) | 5.0 (1,000+) |
| Wordware | Mixed | Yes | Yes | No | Pivoting | $30M | N/A |
| Respell | Yes | Yes | Yes | No | Shutting down | N/A | N/A |

---

## Key Takeaways

### Best for truly non-technical business users
**Relevance AI**, **Cassidy AI**, **Lindy AI**, and **Dust.tt** are the strongest picks. All four have genuine no-code interfaces, support multi-step agent workflows, and are actively building for business teams rather than developers.

### Best for enterprise / regulated industries
**Stack AI** stands out for SOC 2 Type II, HIPAA, GDPR compliance with enterprise features (RBAC, SSO, audit logs). **Botpress** also has strong compliance but requires more technical skill.

### Best for conversational AI specifically
**Voiceflow** (chat + voice) and **Botpress** (multichannel deployment) are the specialists. Voiceflow is more accessible; Botpress is more powerful but developer-oriented.

### Best for developers who want visual building
**Flowise** and **Langflow** are open-source, visually-driven, and powerful — but require understanding of LLM infrastructure concepts. Both have been acquired (Workday and DataStax/IBM respectively), providing financial stability but raising questions about long-term independence.

### Platforms to avoid for new adoption
- **Wordware** — pivoting away from workflow builder to Sauna AI companion
- **Respell** — shutting down March 1, 2026 (team joining Salesforce Agentforce)

### Market dynamics
- The space is consolidating: Workday acquired Flowise, DataStax/IBM acquired Langflow, Salesforce absorbed Respell
- Credit-based pricing is becoming standard but makes cost prediction difficult (Gumloop, Lindy, Voiceflow)
- Per-user pricing (Cassidy at $79/user, Dust at EUR 29/user) can get expensive at scale
- "AI-native" platforms built from scratch (Gumloop, Lindy, Relevance AI) tend to have cleaner UX than legacy tools that bolted on AI
- Multi-model support is table stakes — nearly every platform supports OpenAI, Anthropic, and Google models
