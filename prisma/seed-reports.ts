// Dummy reports seeder.
//
//   npm run prisma:seed:reports             # safe to run more than once
//   npm run prisma:seed:reports -- --reset  # drop the dummy reports and recreate them
//
// Uses fixed ids so re-running skips existing rows and --reset never touches real reports.
// Requires existing REPORTER and APPROVER users (run `npm run prisma:seed` first).
import 'dotenv/config';
import { PrismaPg } from '@prisma/adapter-pg';
import { Prisma, PrismaClient, REPORT_STATUS } from '@prisma/client';

const TOTAL_REPORTS = 100;
const DAYS_BACK = 120;
const RANDOM_SEED = 20261013;

const adapter = new PrismaPg({ connectionString: process.env.DATABASE_URL });
const prisma = new PrismaClient({ adapter });

const reportId = (n: number) => `00000000-0000-4000-8000-${String(n).padStart(12, '0')}`;
const historyId = (n: number, step: number) =>
  `00000000-0000-4000-9${step}00-${String(n).padStart(12, '0')}`;

// Seeded PRNG (mulberry32) so every run generates the same data.
const createRandom = (seed: number) => () => {
  seed |= 0;
  seed = (seed + 0x6d2b79f5) | 0;
  let t = Math.imul(seed ^ (seed >>> 15), 1 | seed);
  t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
  return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
};
const random = createRandom(RANDOM_SEED);
const pick = <T>(items: readonly T[]) => items[Math.floor(random() * items.length)];
const between = (min: number, max: number) => min + random() * (max - min);

const ISSUES = [
  { title: 'Jalan berlubang', detail: 'Terdapat lubang cukup dalam di badan jalan yang membahayakan pengendara motor, terutama saat malam hari.' },
  { title: 'Lampu jalan mati', detail: 'Beberapa lampu penerangan jalan tidak menyala sehingga area menjadi gelap dan rawan kejahatan.' },
  { title: 'Sampah menumpuk', detail: 'Tumpukan sampah belum diangkut lebih dari seminggu dan mulai menimbulkan bau tidak sedap.' },
  { title: 'Saluran air tersumbat', detail: 'Drainase tersumbat lumpur dan sampah sehingga air menggenang setiap kali hujan.' },
  { title: 'Pohon tumbang', detail: 'Pohon tumbang menutup sebagian jalan dan berpotensi menimpa kabel listrik di sekitarnya.' },
  { title: 'Genangan banjir', detail: 'Air setinggi betis menggenang setelah hujan deras dan baru surut setelah beberapa jam.' },
  { title: 'Trotoar rusak', detail: 'Paving trotoar terlepas dan bergelombang sehingga menyulitkan pejalan kaki dan pengguna kursi roda.' },
  { title: 'Rambu lalu lintas hilang', detail: 'Rambu larangan parkir sudah tidak ada sehingga banyak kendaraan parkir sembarangan.' },
  { title: 'Kebocoran pipa air', detail: 'Pipa air bersih bocor dan airnya mengalir ke jalan sejak beberapa hari terakhir.' },
  { title: 'Parkir liar', detail: 'Kendaraan parkir di bahu jalan hingga menyebabkan kemacetan pada jam sibuk.' },
  { title: 'Fasilitas taman rusak', detail: 'Ayunan dan bangku taman rusak sehingga tidak aman digunakan oleh anak-anak.' },
  { title: 'Lampu lalu lintas tidak berfungsi', detail: 'Lampu lalu lintas berkedip kuning terus-menerus sehingga persimpangan menjadi semrawut.' },
  { title: 'Kabel menjuntai', detail: 'Kabel utilitas menjuntai rendah di atas jalan dan dapat tersangkut kendaraan tinggi.' },
  { title: 'Pedagang menutup trotoar', detail: 'Lapak pedagang memenuhi trotoar sehingga pejalan kaki terpaksa berjalan di badan jalan.' },
  { title: 'Polusi suara', detail: 'Kebisingan dari aktivitas konstruksi berlangsung hingga larut malam dan mengganggu warga.' },
] as const;

const LOCATIONS = [
  'Jl. Merdeka', 'Jl. Sudirman', 'Jl. Gatot Subroto', 'Jl. Diponegoro', 'Jl. Ahmad Yani',
  'Jl. Pahlawan', 'Jl. Pemuda', 'Jl. Veteran', 'Jl. Gajah Mada', 'Jl. Hayam Wuruk',
  'Jl. Asia Afrika', 'Jl. Dago', 'Jl. Braga', 'Jl. Cihampelas', 'Jl. Pasteur',
  'Taman Kota', 'Pasar Baru', 'Simpang Lima', 'Alun-alun', 'Terminal Kota',
] as const;

const NOTES = [
  'Mohon segera ditindaklanjuti.',
  'Sudah dilaporkan ke RT setempat namun belum ada tindakan.',
  'Kondisi semakin parah dalam beberapa hari terakhir.',
  'Foto kondisi dapat diberikan jika diperlukan.',
  'Banyak warga sekitar yang mengeluhkan hal ini.',
] as const;

// Roughly 35% pending, 40% approved, 25% rejected.
const pickStatus = (): REPORT_STATUS => {
  const roll = random();
  if (roll < 0.35) return REPORT_STATUS.PENDING;
  if (roll < 0.75) return REPORT_STATUS.APPROVED;
  return REPORT_STATUS.REJECTED;
};

const opposite = (status: REPORT_STATUS) =>
  status === REPORT_STATUS.APPROVED ? REPORT_STATUS.REJECTED : REPORT_STATUS.APPROVED;

const HOUR = 60 * 60 * 1000;
const DAY = 24 * HOUR;

async function main() {
  const reset = process.argv.includes('--reset');

  const [reporters, approvers] = await Promise.all([
    prisma.user.findMany({ where: { role: 'REPORTER', is_active: true }, orderBy: { email: 'asc' } }),
    prisma.user.findMany({ where: { role: 'APPROVER', is_active: true }, orderBy: { email: 'asc' } }),
  ]);

  if (reporters.length === 0 || approvers.length === 0) {
    throw new Error('Need at least one active REPORTER and APPROVER. Run `npm run prisma:seed` first.');
  }

  const ids = Array.from({ length: TOTAL_REPORTS }, (_, i) => reportId(i + 1));

  if (reset) {
    // Histories first because of the report_status_histories -> reports foreign key.
    const deletedHistories = await prisma.reportStatusHistory.deleteMany({ where: { report_id: { in: ids } } });
    const deletedReports = await prisma.report.deleteMany({ where: { id: { in: ids } } });
    console.log(`Removed ${deletedReports.count} dummy reports and ${deletedHistories.count} histories`);
  }

  const now = Date.now();
  const reports: Prisma.ReportCreateManyInput[] = [];
  const histories: Prisma.ReportStatusHistoryCreateManyInput[] = [];

  for (let n = 1; n <= TOTAL_REPORTS; n++) {
    const issue = pick(ISSUES);
    const location = pick(LOCATIONS);
    const reporter = reporters[n % reporters.length];
    const createdAt = new Date(now - between(0, DAYS_BACK) * DAY);
    const status = pickStatus();
    let updatedAt = createdAt;

    if (status !== REPORT_STATUS.PENDING) {
      // Decided 1 hour to 5 days after creation, never in the future.
      let decidedAt = new Date(Math.min(createdAt.getTime() + between(1 * HOUR, 5 * DAY), now));
      const flipped = random() < 0.15;

      if (flipped) {
        // The approver first decided the other way, then changed their mind.
        histories.push({
          id: historyId(n, 1),
          report_id: reportId(n),
          status: opposite(status),
          approver_id: pick(approvers).id,
          created_at: decidedAt,
          updated_at: decidedAt,
        });
        decidedAt = new Date(Math.min(decidedAt.getTime() + between(2 * HOUR, 3 * DAY), now));
      }

      histories.push({
        id: historyId(n, 2),
        report_id: reportId(n),
        status,
        approver_id: pick(approvers).id,
        created_at: decidedAt,
        updated_at: decidedAt,
      });
      updatedAt = decidedAt;
    }

    reports.push({
      id: reportId(n),
      title: `${issue.title} di ${location}`,
      description: `${issue.detail} Lokasi: ${location}. ${pick(NOTES)}`,
      status,
      reporter_id: reporter.id,
      created_at: createdAt,
      updated_at: updatedAt,
    });
  }

  const createdReports = await prisma.report.createMany({ data: reports, skipDuplicates: true });
  const createdHistories = await prisma.reportStatusHistory.createMany({ data: histories, skipDuplicates: true });

  const summary = reports.reduce<Record<string, number>>((acc, r) => {
    acc[r.status as string] = (acc[r.status as string] ?? 0) + 1;
    return acc;
  }, {});

  console.log(
    `Seeded ${createdReports.count} dummy reports (${TOTAL_REPORTS - createdReports.count} already existed) ` +
      `and ${createdHistories.count} status histories`,
  );
  console.log(`Distribution: ${JSON.stringify(summary)} across ${reporters.length} reporter(s)`);
}

main()
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
