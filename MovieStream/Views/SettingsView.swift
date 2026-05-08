import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settingsVM: SettingsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var urlText = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var useMockData = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "gearshape.2.fill").font(.system(size: 40)).foregroundColor(.accentGold)
                        Text("الإعدادات").font(.largeTitle).bold().foregroundColor(.white)
                        Text("قم بإعداد API السيرفر لتشغيل الأفلام").font(.subheadline).foregroundColor(.textSec)
                    }.padding(.top, 20)

                    // API Config
                    GlassCard(cornerRadius: 20) {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("رابط API").font(.headline).foregroundColor(.white)
                            Text("أدخل رابط السيرفر الخاص بك (مثل: https://api.example.com)").font(.caption).foregroundColor(.textSec)
                            TextField("https://...", text: $urlText)
                                .keyboardType(.URL).autocapitalization(.none).disableAutocorrection(true)
                                .foregroundColor(.white).padding(14)
                                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(.white.opacity(0.1), lineWidth: 1))
                                .onAppear { urlText = settingsVM.apiURL }
                            Button {
                                guard !urlText.isEmpty, urlText != settingsVM.apiURL else { return }
                                settingsVM.saveURL(urlText)
                                alertMessage = "تم حفظ الرابط بنجاح ✅"
                                showAlert = true
                            } label: {
                                Label("حفظ", systemImage: "checkmark").font(.headline).foregroundColor(.black)
                                    .frame(maxWidth: .infinity).padding(.vertical, 14)
                                    .background(Color.accentGold, in: RoundedRectangle(cornerRadius: 14))
                            }.buttonStyle(.plain).disabled(urlText.isEmpty)
                        }.padding(20)
                    }.padding(.horizontal, 16)

                    // Or use mock data
                    GlassCard(cornerRadius: 20) {
                        VStack(spacing: 14) {
                            Text("بدون API؟").font(.headline).foregroundColor(.white)
                            Text("يمكنك استخدام بيانات تجريبية لمشاهدة واجهة التطبيق").font(.caption).foregroundColor(.textSec).multilineTextAlignment(.center)
                            Button {
                                settingsVM.saveURL("")
                                NotificationCenter.default.post(name: Notification.Name("APIConfigured"), object: nil)
                                dismiss()
                            } label: {
                                Label("استخدام بيانات تجريبية", systemImage: "film.fill").font(.headline).foregroundColor(.white)
                                    .frame(maxWidth: .infinity).padding(.vertical, 14)
                                    .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 14))
                            }.buttonStyle(.plain)
                        }.padding(20)
                    }.padding(.horizontal, 16)

                    // Info
                    GlassCard(cornerRadius: 20) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("معلومات").font(.headline).foregroundColor(.white)
                            InfoRow(icon: "1.circle", text: "التطبيق يعمل مع أي API يتوافق مع هيكل البيانات")
                            InfoRow(icon: "2.circle", text: "يمكنك تعديل هيكل API من ملف Services.swift")
                            InfoRow(icon: "3.circle", text: "البيانات التجريبية تحتوي على 24 فيلم وعمل")
                        }.padding(20)
                    }.padding(.horizontal, 16)

                    // Status
                    HStack {
                        Circle().fill(settingsVM.isConfigured ? Color.green : Color.red).frame(width: 8)
                        Text(settingsVM.isConfigured ? "API متصل" : "API غير متصل").font(.caption).foregroundColor(.textSec)
                    }
                }.padding(.bottom, 30)
            }
            .background(Color.bgGradient)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button { dismiss() } label: { Text("تم").bold().foregroundColor(.accentGold) }
                }
            }
        }
        .alert("تم", isPresented: $showAlert) {
            Button("حسناً") { dismiss() }
        } message: {
            Text(alertMessage)
        }
    }
}

struct InfoRow: View {
    let icon: String; let text: String
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon).foregroundColor(.accentGold).font(.caption)
            Text(text).font(.caption).foregroundColor(.textSec)
        }
    }
}
