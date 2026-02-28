# Enterprise Platform AI Agent Capabilities

Research date: 2026-02-27

How mainstream enterprise automation and SaaS platforms are adding AI agent capabilities for non-technical users.

---

## Market Context

Gartner predicts 40% of enterprise apps will feature task-specific AI agents by end of 2026, up from <5% in 2025. However, Gartner also warns that >40% of agentic AI projects will be canceled by end of 2027 due to escalating costs, unclear business value, or inadequate risk controls. Only ~130 of thousands of claimed agentic AI vendors offer legitimate agent technology — the rest are "agent washing" (rebranding chatbots/RPA as agents).

Deloitte's 2025 research: 30% of organizations exploring agentic options, 38% piloting, but only 14% deployment-ready and 11% in production.

Sources:
- https://www.gartner.com/en/newsroom/press-releases/2025-08-26-gartner-predicts-40-percent-of-enterprise-apps-will-feature-task-specific-ai-agents-by-2026-up-from-less-than-5-percent-in-2025
- https://www.gartner.com/en/newsroom/press-releases/2025-06-25-gartner-predicts-over-40-percent-of-agentic-ai-projects-will-be-canceled-by-end-of-2027
- https://www.deloitte.com/us/en/insights/topics/technology-management/tech-trends/2026/agentic-ai-strategy.html

---

## Platform Summaries

### 1. Zapier — Agents + Central

**What they offer:** Zapier Agents are AI assistants that work autonomously across 7,000+ app integrations. Instead of rigid if/then rules, you give natural language instructions and the agent decides how to accomplish goals. Agents can browse the web, access real-time data from connected apps ("Live Data Sources"), and execute multi-step workflows. Announced at ZapConnect 2025: Copilot (AI assistant for building workflows), human-in-the-loop controls, and MCP support coming in 2026.

**UX for non-technical users:** Natural language instructions — you describe what you want and the agent figures it out. Building workflows still uses the familiar Zap visual editor. Copilot (AI builder assistant) further lowers the bar by helping construct workflows conversationally.

**Pricing:**
- Free: 400 agent activities/month
- Pro ($29.99/mo): 1,500 agent activities/month
- Team ($103.50/mo): Higher limits
- Enterprise: Custom
- Activities = agent actions, web browsing, knowledge lookups

**Enterprise adoption:** 72% of enterprises actively using or testing AI agents (Zapier's own survey of 500+ US enterprise leaders, Dec 2025). 84% plan to increase AI agent investment in next 12 months. Security/privacy cited as primary barrier.

**Integration depth:** 7,000+ apps, 450+ AI-specific integrations, 8,500+ total integrations claimed.

**Limitations:** Agent activities are a separate consumption metric from Zap tasks — costs can stack. Agents are still relatively new (launched 2024-2025) and best suited for structured workflows rather than truly open-ended reasoning. Human-in-the-loop is the most common enterprise deployment pattern, suggesting full autonomy isn't trusted yet.

Sources:
- https://zapier.com/agents
- https://zapier.com/blog/december-2025-product-updates/
- https://zapier.com/pricing
- https://finance.yahoo.com/news/zapier-survey-finds-84-enterprises-130000504.html

---

### 2. Make.com — AI Agents (Next Gen)

**What they offer:** Make AI Agents launched April 2025, with next-gen version announced October 2025 and rolling out February 2026. Agents are built inside the same visual canvas as Make scenarios — they interpret input, choose tools, and adapt within workflows. Multi-modal support (PDFs, images, CSVs). Pre-built agent templates that combine deterministic automation with AI agents can be shared across teams.

**UX for non-technical users:** Visual drag-and-drop canvas — same interface for scenarios and agents. Every AI decision is visible and reviewable on the canvas. Transparency is a core selling point: you can see and debug agent reasoning in-place. Bring-your-own AI provider (connect to OpenAI, Anthropic, etc. with your API key).

**Pricing:**
- Free: 1,000 operations/month
- Core: $9/mo for 10,000 operations
- Pro: $16/mo for 10,000 operations (includes AI scenario suggestions)
- Teams: $29/mo for 10,000 operations
- Enterprise: Custom
- AI token costs are paid directly to your AI provider (not to Make)
- Unused operations roll over one month on paid plans (added Nov 2025)

**Enterprise adoption:** 3,000+ app integrations including 350+ AI-specific applications. Strong in mid-market and agencies. Less enterprise penetration than Zapier.

**Integration depth:** 3,000+ apps, 350+ AI apps.

**Limitations:** BYOK model means you manage AI provider costs separately — total cost is less predictable. Agent features are very new (next-gen just launching Feb 2026). The visual canvas approach is powerful for debugging but may be overwhelming for truly non-technical users building complex agent logic.

Sources:
- https://www.make.com/en/ai-agents
- https://www.make.com/en/blog/announcing-next-generation-make-ai-agents
- https://www.make.com/en/pricing
- https://www.make.com/en/blog/next-generation-make-AI-agents

---

### 3. Microsoft — Power Automate + Copilot Studio

**What they offer:** Two-tier approach. **Agent Builder** (inside Microsoft 365 Copilot) is for non-technical users: build agents with natural language, no code, drag-and-drop uploads. **Copilot Studio** is the full platform: generative actions, multi-agent orchestration, code interpreter (Python execution), 1,400+ connectors, MCP server support, and VS Code integration for developers. GPT-5 Chat available in Copilot Studio since Nov 2025. Agent Factory (announced 2026) for building agents via Microsoft Foundry.

**UX for non-technical users:** Agent Builder is genuinely no-code — build in context within Microsoft 365 apps. Full-screen editing, drag-and-drop. Copilot Studio is more complex (low-code) but far more powerful. The split means non-technical users have an easy on-ramp, but sophisticated agents require the Studio.

**Pricing:**
- Included with Microsoft 365 Copilot license ($30/user/month) for basic internal agents
- Copilot Studio standalone: $200/month per 25,000 Copilot Credits
- Pay-as-you-go option available (consume credits, pay monthly)
- Credit consumption varies by agent complexity and features used
- Shifted from per-message to credit-based model (Sep 2025)

**Enterprise adoption:** Massive installed base via Microsoft 365. Multi-agent orchestration enables routing between specialized agents. Deep integration with Microsoft ecosystem (Teams, SharePoint, Outlook, Dynamics 365). Enterprise-grade governance and compliance built in.

**Integration depth:** 1,400+ connectors. Native integration with entire Microsoft stack. MCP support. Power Platform ecosystem (Power Apps, Power BI, Dataverse).

**Limitations:** Credit-based pricing is opaque — hard to predict costs before deploying. Agent Builder is limited compared to full Copilot Studio. The Microsoft ecosystem lock-in is real: agents work best within Microsoft tools. Multi-agent orchestration is powerful but adds complexity. The gap between Agent Builder (easy) and Copilot Studio (complex) can be jarring.

Sources:
- https://www.microsoft.com/en-us/microsoft-365-copilot/microsoft-copilot-studio
- https://learn.microsoft.com/en-us/microsoft-copilot-studio/billing-licensing
- https://learn.microsoft.com/en-us/power-platform/release-plan/2025wave2/microsoft-copilot-studio/
- https://blog.bismart.com/en/copilot-agent-builder-vs-copilot-studio-microsoft-ai-agents

---

### 4. ServiceNow — AI Agents + Now Assist

**What they offer:** AI Agents handle multistep workflows, make judgment calls, and resolve issues autonomously within ServiceNow's ITSM/HR/CSM ecosystem. AI Agent Orchestrator coordinates teams of specialized agents across departments. AI Agent Studio for building custom agents. Now Assist provides generative AI features (summarization, content generation) embedded across the platform. Available since March 2025.

**UX for non-technical users:** AI Agent Studio provides a builder interface, but ServiceNow has always been a platform that requires trained administrators. Non-technical business users interact with agents as end-users (e.g., chatting with an IT support agent), but building agents requires ServiceNow platform knowledge.

**Pricing:**
- Not publicly listed — custom quotes only
- Requires Pro or Enterprise tier, plus separate Now Assist add-on license
- Pro Plus package has ~60% price uplift over Pro
- Fulfiller licenses estimated at $70-$100/user/month for base ITSM
- AI agent features are a significant additional cost

**Enterprise adoption:** Strong. Now Assist passed $600M ACV (doubling YoY). 244 enterprise deals >$1M in Q4 2025. Notable case studies: Orica (IT deflection 18% to 94%), Lloyd's Bank (90% HR case deflection), Pandora (via integration). Q4 2025 subscription revenue $3.4B (+21% YoY).

**Integration depth:** Deep within ServiceNow ecosystem (ITSM, HRSD, CSM, SecOps). Integrations with Microsoft 365 Copilot announced. Limited compared to Zapier/Make for third-party app breadth — strength is depth within enterprise IT/HR/service management.

**Limitations:** Expensive — enterprise pricing with opaque costs. Building agents requires ServiceNow expertise, not a no-code play for business users. Primarily valuable within ServiceNow's own workflows (IT, HR, customer service). Not a general-purpose agent builder.

Sources:
- https://www.servicenow.com/products/ai-agents.html
- https://newsroom.servicenow.com/press-releases/details/2025/ServiceNow-announces-new-agentic-AI-innovations-to-autonomously-solve-the-most-complex-enterprise-challenges-01-29-2025-traffic/default.aspx
- https://www.eesel.ai/blog/how-much-does-servicenow-ai-platform-cost
- https://www.kellton.com/kellton-tech-blog/servicenow-agentic-ai-2026-guide

---

### 5. Salesforce — Agentforce

**What they offer:** Agentforce (formerly Einstein Bots) runs on the Atlas Reasoning Engine with three AI capabilities: Predictive AI (forecasting), Generative AI (content), and Agentic AI (autonomous task execution). Agents execute "Actions" — updating records, summarizing cases, answering inquiries, running prompts/flows. Multi-step autonomous workflows within Salesforce CRM context. Agentforce 360 launched for full-platform coverage.

**UX for non-technical users:** Low-code builder within Salesforce. Agents are configured through natural language instructions and connected to Salesforce flows/actions. Requires Salesforce admin knowledge to set up properly. End users interact conversationally. Not truly no-code for building — more "low-code for Salesforce admins."

**Pricing:** Three concurrent models:
- **Flex Credits:** $0.10/action ($500 for 100,000 credits, 20 credits per action)
- **Per-user add-ons:** $125/user/month (Sales, Service, Field Service) or $150/user/month (regulated industries)
- **Agentforce 1 Editions:** From $550/user/month (comprehensive AI suite)
- 6% overall pricing increase announced alongside unlimited Agentforce licenses

**Enterprise adoption:** Fastest-growing Salesforce product ever. $540M ARR by Q3 FY2026, 330% YoY growth. 18,500 total deals, 9,500 paid. Notable customers: Pandora (60% case deflection), 1-800Accountant (70% autonomous resolution), Datasite (70% chat resolution), UK police forces (82% citizen query resolution without escalation). Salesforce's own deployment: 1.5M+ support requests handled, $1.7M pipeline from SDR agent.

**Integration depth:** Native to Salesforce ecosystem (Sales Cloud, Service Cloud, Marketing Cloud, etc.). Connects to external systems via MuleSoft and Salesforce integrations. Strongest within CRM workflows.

**Limitations:** Pricing is genuinely confusing — three concurrent models with different units. Primarily CRM-focused; not a general-purpose agent builder. Requires existing Salesforce investment. The $125-$550/user/month costs add up fast. "Agent washing" criticism — some features are enhanced automation rather than truly autonomous agents.

Sources:
- https://www.salesforce.com/agentforce/pricing/
- https://www.salesforce.com/agentforce/customer-stories/
- https://www.salesforce.com/news/stories/first-year-agentforce-customer-zero/
- https://www.getmonetizely.com/blogs/the-doomed-evolution-of-salesforces-agentforce-pricing

---

### 6. Google — Vertex AI Agent Builder

**What they offer:** Part of Google Cloud. Build agents with no-code drag-and-drop interface or via code (LangChain, LlamaIndex, ADK). RAG for combining LLM responses with real-time data. Multi-language NLU. Data Connector Framework for Google Workspace, third-party databases, custom APIs. Supports Gemini 3 Pro/Flash models. Tool governance via Cloud API Registry. Agent Development Kit (ADK) now supports TypeScript.

**UX for non-technical users:** Has a no-code drag-and-drop interface, but primarily developer-oriented. The Google Cloud console is not intuitive for non-technical users. Express Mode allows getting started without billing enabled. More suited for technical teams building customer-facing agents than for business users creating their own workflows.

**Pricing:**
- Pay-as-you-go: $0.00994/vCPU-hour, $0.0105/GiB-hour for memory
- Model/search query charges vary by model
- Agent Engine runtime pricing lowered recently
- Sessions, Memory Bank, Code Execution billing started Jan 28, 2026
- Express Mode available with limited quotas (no billing required)

**Enterprise adoption:** Leverages Google Cloud's enterprise customer base. Integrated with Google Workspace and BigQuery. IAM policies inherited from Google Cloud project. Less visible adoption data compared to Salesforce/ServiceNow.

**Integration depth:** Google Workspace, BigQuery, Cloud Storage, custom APIs via Data Connector Framework. Framework support (LangChain, LlamaIndex). MCP support likely coming.

**Limitations:** Developer-first platform despite no-code claims. Google Cloud console has a steep learning curve. Pricing is complex and usage-based — hard to predict. Less suited for business-user agent building compared to Zapier or Copilot Studio. Competes more with AWS Bedrock than with Zapier/Make.

Sources:
- https://cloud.google.com/products/agent-builder
- https://cloud.google.com/vertex-ai/generative-ai/pricing
- https://docs.google.com/agent-builder/release-notes
- https://latenode.com/blog/ai-agents-autonomous-systems/ai-agent-builders-development-tools/google-vertex-ai-agent-builder-2025-complete-platform-guide

---

### 7. Amazon — Bedrock Agents + AgentCore

**What they offer:** Bedrock Agents for building AI agents with tool use, knowledge bases, and multi-step reasoning. AgentCore (GA October 2025) adds Runtime, Memory (including episodic memory), Gateway, Identity, and Observability as managed services. AgentCore Gateway provides centralized tool server with MCP support. Policy engine (preview) for natural language guardrails that convert to Cedar policy language. Agent evaluation with 13 built-in evaluators.

**UX for non-technical users:** Developer-focused. AWS console, SDKs, and infrastructure management. Not designed for non-technical users at all. Enterprise developers and ML engineers are the target audience.

**Pricing:**
- Search API: $25 per million invocations
- InvokeTool API: $5 per million invocations
- SearchToolIndex: $0.02 per 100 tools
- Plus underlying model costs (pay per token)
- Agent orchestration multiplies costs: a single query can trigger 10x expected tokens due to internal reasoning loops
- Lambda function costs for Action Groups ($0.20/1M requests)

**Enterprise adoption:** AWS's massive enterprise footprint. Partners include Informatica, Accenture. VPC, PrivateLink, CloudFormation, and resource tagging support for enterprise security. Less direct adoption data published compared to Salesforce.

**Integration depth:** Any AWS service. MCP support via AgentCore Gateway. Framework-agnostic (use any agent framework). Strong for enterprises already on AWS.

**Limitations:** Entirely developer-focused — zero no-code capability. Complex pricing that multiplies with agent reasoning steps. AWS console complexity. Primarily infrastructure, not a business-user tool. Competes with Google Vertex, not with Zapier/Make.

Sources:
- https://aws.amazon.com/bedrock/agents/
- https://aws.amazon.com/bedrock/agentcore/
- https://aws.amazon.com/bedrock/agentcore/pricing/
- https://techcrunch.com/2025/12/02/aws-announces-new-capabilities-for-its-ai-agent-builder/

---

### 8. HubSpot — Breeze AI Agents

**What they offer:** Breeze is HubSpot's AI suite with specialized agents: Prospecting Agent (researches accounts, personalizes outreach), Content Agent (scales content across channels), Knowledge Base Agent (expands support resources), Customer Agent (24/7 query resolution), and Closing Agent (answers buyer questions). Run Agent workflow action triggers agents within HubSpot workflows. Upgraded to GPT-5 as of Jan 2026.

**UX for non-technical users:** HubSpot has always prioritized ease of use. Agents are pre-built and specialized — you configure them rather than building from scratch. The Run Agent workflow action lets you embed agent steps into existing HubSpot automations. Very accessible for marketing/sales/service teams already on HubSpot.

**Pricing:**
- Free/Starter: Basic AI assistance only
- Professional ($450-$800/mo per Hub): Core agents like Customer Agent
- Enterprise ($1,500-$3,600/mo per Hub): Advanced agents like Prospecting Agent
- Credit system: 3,000 credits (Pro) or 5,000 credits (Enterprise) included
- 1 Customer Agent conversation = 100 credits (~$1.00)

**Enterprise adoption:** Strong in SMB and mid-market. 200+ product updates at Spring 2025 and INBOUND 2025. Data Hub for unified business data. Less enterprise penetration than Salesforce/ServiceNow.

**Integration depth:** HubSpot ecosystem (CRM, Marketing Hub, Sales Hub, Service Hub). 1,500+ app marketplace integrations. MCP integrations with Lovable, Perplexity, Mistral.

**Limitations:** Agents are pre-built and specialized — you can't build arbitrary custom agents. Limited to HubSpot's workflow paradigm. Per-conversation credit costs add up for high-volume use cases. Full agent access requires Professional+ pricing, which is expensive for SMBs. Agent capabilities are narrowly scoped to HubSpot's go-to-market use cases.

Sources:
- https://www.hubspot.com/products/artificial-intelligence/breeze-ai-agents
- https://ir.hubspot.com/news-releases/news-release-details/hubspot-launches-new-and-enhanced-ai-agents-plus-over-200
- https://www.eesel.ai/blog/hubspot-ai-pricing
- https://vantagepoint.io/blog/hs/how-to-use-breeze-ai-agents-hubspot

---

### 9. Monday.com — AI Agents + Digital Workforce

**What they offer:** AI Workflows for multi-step task automation. Monday Sidekick as personal AI assistant (out of beta, main AI entry point). Agent Factory for creating personalized agents. "Digital Workforce" concept: AI-powered agents that handle project risk analysis, sales deal unblocking, and customer service issue identification. Monday Expert (first agent, launched March 2025) for onboarding and platform guidance. AI Blocks, Product Power-ups, and AI skills marketplace.

**UX for non-technical users:** Monday.com's core strength. AI features are embedded into the familiar board/workflow interface. Monday Sidekick is conversational. AI Workflows use the existing automation builder. Designed for project managers and ops teams, not developers.

**Pricing:**
- All plans: 500 free AI credits/month
- Additional credit buckets: 2,500 to 250,000 credits
- Standard plans start at $12/seat/month
- Pro plans at $19/seat/month
- Enterprise: Custom
- Specific Digital Workforce pricing not yet published

**Enterprise adoption:** Expanding with enterprise-grade capabilities (announced alongside AI agents). Digital Workers planned for Q2 2025. Agent marketplace for Q4 2025. Less mature AI agent offering compared to larger enterprise platforms.

**Integration depth:** 200+ integrations. Less breadth than Zapier/Make. Focused on work management context (project management, CRM, dev, service).

**Limitations:** AI agent features are very new and still rolling out. Digital Workforce is more vision than reality at this stage. Credit system limits are low on base plans. Agents are focused on monday.com's own workspace context — not general-purpose automation across external tools. Less powerful for cross-app workflows than Zapier or Make.

Sources:
- https://monday.com/w/ai
- https://ir.monday.com/news-and-events/news-releases/news-details/2025/monday-com-Expands-AI-Powered-Agents-CRM-Suite-and-Enterprise-Grade-Capabilities/default.aspx
- https://support.monday.com/hc/en-us/articles/29544502265746-AI-Credits
- https://community.monday.com/t/ai-2026-what-s-new-and-what-s-coming/123164

---

### 10. Notion — AI Agents + Custom Agents

**What they offer:** Notion 3.0 (Sep 2025) rebuilt Notion AI as Agents. Agents can do anything a user can do in Notion — create/update hundreds of pages, build launch plans, break projects into tasks, assign work, draft docs. 20+ minutes of multi-step actions with state-of-the-art memory system. Custom Agents (Feb 2026) are fully autonomous — set a trigger or schedule and they run 24/7 for task triaging, internal Q&A, daily standups, inbox zero. Instructions page for personalization.

**UX for non-technical users:** Excellent. Natural language interface. Agents operate within the familiar Notion workspace. Custom Agents have a simple setup: give them a job, set a trigger/schedule. No coding required. Mobile support (Jan 2026).

**Pricing:**
- Notion AI features included in Business ($15/user/mo) and Enterprise plans
- Custom Agents: Free trial through May 3, 2026
- After trial: $10 per 1,000 Notion credits (add-on)
- Credit usage varies by task complexity
- Business and Enterprise plans only (no Free/Plus)
- Credits shared across workspace, reset monthly (no rollover)

**Enterprise adoption:** Strong Notion user base. MCP integrations with Lovable, Perplexity, Mistral, HubSpot for cross-tool context. Custom Agents just launched (Feb 2026) — too early for adoption data.

**Integration depth:** Notion ecosystem (pages, databases, wikis). MCP integrations expanding. Not a cross-app automation platform — agents work within Notion's workspace.

**Limitations:** Agents are Notion-scoped — they can do anything in Notion but can't directly trigger external workflows (no equivalent of Zapier's 7,000 app integrations). Custom Agents are brand new (Feb 2026) with no track record. Credit costs are unpredictable since they vary by complexity. No Free/Plus plan access.

Sources:
- https://www.notion.com/releases/2025-09-18
- https://www.notion.com/releases/2026-02-24
- https://www.notion.com/help/custom-agent-pricing
- https://www.notion.com/blog/introducing-custom-agents

---

## Comparison Matrix

| Platform | Agent Type | Non-Technical UX | Pricing Model | Integration Breadth | Best For |
|----------|-----------|------------------|---------------|-------------------|----------|
| **Zapier** | General-purpose autonomous | High (natural language) | Activities ($30-104+/mo) | 7,000+ apps | Cross-app workflow automation |
| **Make.com** | Visual canvas agents | Medium-High (visual) | Operations + BYOK AI ($9-29+/mo) | 3,000+ apps | Technical teams wanting transparency |
| **Copilot Studio** | Enterprise agents | High (Agent Builder) / Medium (Studio) | Credits ($200/25K credits) | 1,400+ connectors | Microsoft-ecosystem enterprises |
| **ServiceNow** | IT/HR/Service agents | Low (admin-focused) | Custom quotes ($$$$) | ServiceNow ecosystem | Enterprise IT/HR service management |
| **Salesforce** | CRM agents | Medium (Salesforce admin) | $0.10/action or $125-550/user/mo | Salesforce + MuleSoft | CRM-centric enterprises |
| **Google Vertex** | Developer agent platform | Low (developer tools) | Pay-as-you-go (usage) | Google Cloud + APIs | Technical teams on GCP |
| **AWS Bedrock** | Developer agent infra | Very Low (AWS console) | Per-invocation + tokens | AWS ecosystem | Engineering teams on AWS |
| **HubSpot** | Pre-built GTM agents | High (pre-configured) | Credits ($450-3,600/mo) | 1,500+ HubSpot apps | Marketing/Sales/Service teams |
| **Monday.com** | Workspace agents | High (board-native) | AI credits (500 free/mo) | 200+ integrations | Project/ops teams |
| **Notion** | Workspace agents | Very High (natural language) | Credits ($10/1K, Business+ only) | Notion + MCP partners | Knowledge workers, docs/project mgmt |

---

## Key Themes Across Platforms

### 1. Two distinct categories
Enterprise platforms fall into two groups:
- **Horizontal automation** (Zapier, Make): General-purpose, cross-app agent builders for broad workflow automation
- **Vertical SaaS + AI** (Salesforce, ServiceNow, HubSpot, Monday, Notion): AI agents embedded within an existing product, scoped to that product's domain

The cloud providers (AWS, Google, Microsoft) sit in between — offering infrastructure that can be either.

### 2. The "agent" label is stretched thin
What platforms call "agents" ranges widely:
- **Autonomous multi-step reasoning** (Zapier Agents, Make AI Agents, Copilot Studio): Genuine agent behavior — interpreting goals, choosing tools, adapting
- **Pre-built specialized bots** (HubSpot Breeze, Monday Expert): Pre-configured for specific tasks, limited customization
- **Enhanced automation with AI steps** (some Monday workflows, basic Notion agents): Traditional automation + LLM calls, not truly agentic

Gartner's warning about "agent washing" applies broadly.

### 3. Pricing is universally confusing
Every platform uses a different consumption unit: activities (Zapier), operations (Make), credits (Microsoft, HubSpot, Monday, Notion), actions (Salesforce), invocations (AWS), vCPU-hours (Google). None make it easy to predict costs before deploying. The multi-step nature of agents amplifies this — a single user request can trigger 5-10x the expected consumption.

### 4. Non-technical UX varies enormously
- **Genuinely accessible**: Zapier (natural language), Notion (natural language), HubSpot (pre-built agents), Monday (board-native)
- **Low-code/admin-required**: Salesforce (Salesforce admin), Copilot Studio (Power Platform knowledge), ServiceNow (platform admin)
- **Developer-only**: AWS Bedrock, Google Vertex

### 5. Human-in-the-loop is the norm, not the exception
Full autonomy is rare in production. Most enterprises deploy agents with human approval gates, especially for customer-facing or high-stakes workflows. This is a feature (governance) not a limitation.

### 6. Integration depth beats breadth for enterprise adoption
The strongest enterprise adoption stories (Salesforce $540M ARR, ServiceNow $600M ACV) come from deep integration within existing enterprise ecosystems, not from connecting the most apps. Enterprises adopt agents where their data already lives.

---

## Reality Check: Marketing vs. Production

Based on IBM's 2025 analysis, MIT research, and Deloitte surveys:
- **80%+ of AI implementations fail within 6 months**
- **95% of enterprise AI pilots fail to deliver expected returns** (MIT)
- **Only 23% of enterprises are actually scaling AI agents** (McKinsey)
- **Only 11% have agents in production** (Deloitte)
- **Highest-ROI deployments are "boring" tasks**: document processing, data reconciliation, compliance checks, invoice handling

The gap between marketing (autonomous AI teammates!) and reality (structured task automation with human oversight) remains wide across all platforms.

Sources:
- https://www.ibm.com/think/insights/ai-agents-2025-expectations-vs-reality
- https://digidai.github.io/2026/01/18/year-of-ai-agents-concept-to-production-reality-gap/
- https://www.kore.ai/blog/ai-agents-in-2026-from-hype-to-enterprise-reality
