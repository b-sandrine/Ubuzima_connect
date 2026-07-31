# Ubuzima Connect — Presentation Script

**Presenter:** Beulla  
**Focus:** Authentication, CHW experience, clinical AI, patient list & alerts  
**Suggested length:** 6–8 minutes (+ 2–3 min live demo)

---

## 0. Setup before you start (30 sec, silent)

1. App running on an Android emulator/device.
2. Firebase project `ubuzima-connect-alu` open in a browser tab (optional: show `users` collection).
3. Have a CHW test account ready (phone or email + password).
4. Showcase hub / CHW flow bookmarked so you don’t hunt for screens.

---

## 1. Opening (45 sec)

> Good [morning/afternoon]. I’m **Beulla**, and I’ll walk through the parts of **Ubuzima Connect** I owned.
>
> Ubuzima Connect is an offline-first healthcare app for Rwanda. It connects three roles: **Community Health Workers**, **Doctors**, and **Patients**.
>
> My work sits at the front door of that system — **who you are, how you get in, and what a CHW sees when they start their day** — including **AI-assisted clinical support**.

**On screen:** App splash / welcome page.

---

## 2. Problem & my scope (45 sec)

> In rural care, CHWs are often the first point of contact. They need:
>
> 1. A simple way to sign in — including by phone.
> 2. A clear home screen with today’s priorities.
> 3. Fast access to their patients.
> 4. Help spotting risk — without replacing clinical judgment.
>
> So I focused on:
>
> - **Welcome, login, registration, and password reset**
> - **Role-aware auth** (CHW / Doctor / Patient) wired to Firebase and Firestore
> - The **CHW dashboard**
> - A live **patient list** from intake data
> - **Alerts / notifications**
> - A shared **Clinical AI** layer powered by Gemini

**On screen:** Role selection → highlight the three roles.

---

## 3. Authentication (90 sec)

> Starting with authentication.
>
> Users land on a **welcome** screen, pick a role, then see a **role-specific login**. For CHWs, that includes phone *or* email, remember-me, and clear error handling when credentials are wrong.
>
> On register, we create the Firebase Auth user **and** a Firestore profile under `users/{uid}` with the selected role — patient, doctor, or community health worker.
>
> On login, we also **ensure that profile exists**, so you don’t end up authenticated in Auth but invisible in Firestore.
>
> Route guards then enforce **authorization**: an authenticated doctor can’t casually open CHW-only routes, and after login each role goes to the right home.

**Demo clicks:**
1. Welcome → Role selection → CHW.
2. Try wrong password → show “Incorrect email or password.”
3. Sign in successfully → land on CHW dashboard.
4. *(Optional)* Show Firestore `users/{uid}` with `role: chw`.

**Say while demoing:**
> Wrong credentials fail loudly in the UI. Successful login provisions the profile and routes by role — that’s authentication plus authorization, not just a pretty form.

---

## 4. CHW dashboard (75 sec)

> Once a CHW is in, they see the **dashboard** — their operational home.
>
> It surfaces what matters for the day: **emergency alerts**, **upcoming visits**, and an **AI day briefing** built from live caseload data — not a static mock forever.
>
> Bottom navigation ties the CHW flow together: dashboard, patients, records, settings, and related screens.
>
> The goal was simple: open the app and know **who needs attention first**.

**Demo clicks:**
1. Point at alerts panel / active alert count.
2. Point at upcoming visits.
3. Point at AI briefing card.
4. Tap bottom nav once so the structure is clear.

---

## 5. Patient list (60 sec)

> From the dashboard I integrated a **patient list** backed by the patient-intake pipeline.
>
> Instead of hard-coded names, the CHW sees **registered patients** from Firestore — searchable and ready to open into a health record.
>
> That closes the loop: intake → caseload → follow-up.

**Demo clicks:**
1. Open CHW patient list.
2. Scroll / search if available.
3. Open one patient → health record (brief glance).

**Say:**
> This is the difference between a UI prototype and a usable field tool — the list is real data the team already captures at intake.

---

## 6. Clinical AI (90 sec)

> The AI work is a shared service: `ClinicalAiService`, implemented with **Firebase AI Logic / Gemini**.
>
> It’s used across roles, but for CHWs it powers things like:
>
> - Day briefings from caseload context
> - Health-record assessment summaries
> - Regenerating an assessment when the record changes
>
> Important design choice: AI **assists**; it doesn’t silently invent care. When generation fails, we fall back to safe, readable messages so the app still works offline or under quota limits.
>
> I also wired AI into doctor and patient surfaces where clinical context already existed — so one service, many screens, consistent behavior.

**Demo clicks:**
1. On CHW dashboard, show AI briefing text.
2. Open a health record → AI assessment card.
3. *(If stable)* tap regenerate assessment and wait for update.

**Say:**
> Clinicians stay in control. AI shortens the time to “what should I look at next?”

---

## 7. Alerts & notifications (45 sec)

> Finally, alerts. CHWs and clinicians need more than a pretty home screen — they need **actionable notifications**.
>
> I built out the **alerts experience** and tightened how alert context feeds the AI layer, so priority patients aren’t buried in a generic inbox.

**Demo clicks:**
1. Open notifications / alerts page.
2. Point at a priority/medication or emergency-style alert.
3. Return to dashboard so the story connects: alert → patient → record.

---

## 8. Closing (45 sec)

> To recap what I delivered:
>
> 1. **Auth end-to-end** — welcome, login, register, reset, Firestore profiles, role-based routing  
> 2. **CHW home experience** — dashboard oriented around today’s work  
> 3. **Live patient list** integrated with intake  
> 4. **Clinical AI** via Gemini for briefings and assessments  
> 5. **Alerts** so urgent cases surface clearly  
>
> Together, this is the path from “open the app” to “help this patient today.”
>
> Happy to take questions — or I can dig into architecture: Clean Architecture layers, BLoC, or the Firestore profile flow.

---

## Quick Q&A cheat sheet

| Likely question | Short answer |
|---|---|
| Why phone login for CHWs? | Many CHWs are more comfortable with phone numbers; we map a normalized Rwandan number to a stable Firebase email identity. |
| Where is the user stored? | Firebase Auth for credentials; Firestore `users/{uid}` for profile + role. |
| Does AI replace the clinician? | No — it summarizes and prioritizes; decisions stay with the CHW/doctor. |
| What if AI fails? | Fallback text so the UI never blank-fails. |
| Clean Architecture? | Presentation (BLoC/UI) → Domain (use cases) → Data (Firebase/local). UI never talks to Firestore directly. |
| Offline? | Local sources + sync patterns exist in the architecture; AI needs network, core caseload paths are designed offline-first. |

---

## Timing card (glance while presenting)

| Block | Time |
|---|---|
| Opening + problem | ~1.5 min |
| Auth + demo | ~2 min |
| Dashboard + patient list | ~2 min |
| AI + alerts | ~2 min |
| Close | ~0.5 min |
| **Total talk** | **~8 min** |
| Buffer / Q&A | 2–4 min |

---

## Optional one-liner (if you only get 20 seconds)

> I built Ubuzima Connect’s front door and CHW daily workflow: role-aware Firebase auth, the CHW dashboard, a live patient list, Gemini clinical AI, and alerts — so a community health worker can sign in and know who needs care first.
