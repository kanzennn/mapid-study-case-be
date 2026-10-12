import 'dotenv/config';
import { PrismaPg } from '@prisma/adapter-pg';
import { PrismaClient } from '@prisma/client';
import { hashPassword } from '../src/utils/password';

const ADMIN_EMAIL = 'administrator@gmail.com';
const ADMIN_PASSWORD = 'Admin1234!';

const APPROVER_EMAIL = 'approver@gmail.com';
const APPROVER_PASSWORD = 'Approver1234!';

const REPORTER1_EMAIL = 'reporter1@gmail.com';
const REPORTER1_PASSWORD = 'Reporter1234!';

const REPORTER2_EMAIL = 'reporter2@gmail.com';
const REPORTER2_PASSWORD = 'Reporter1234!';

const adapter = new PrismaPg({ connectionString: process.env.DATABASE_URL });
const prisma = new PrismaClient({ adapter });

async function main() {

  await prisma.user.upsert({
    where: { email: ADMIN_EMAIL },
    update: {},
    create: {
      name: 'Administrator',
      email: ADMIN_EMAIL,
      password: await hashPassword(ADMIN_PASSWORD),
      role: 'ADMIN',
    },
  });

  console.log(`Seeded admin user: ${ADMIN_EMAIL}`);

  await prisma.user.upsert({
    where: { email: APPROVER_EMAIL },
    update: {},
    create: {
      name: 'Approver',
      email: APPROVER_EMAIL,
      password: await hashPassword(APPROVER_PASSWORD),
      role: 'APPROVER',
    },
  });

  console.log(`Seeded approver user: ${APPROVER_EMAIL}`);

  await prisma.user.upsert({
    where: { email: REPORTER1_EMAIL },
    update: {},
    create: {
      name: 'Reporter 1',
      email: REPORTER1_EMAIL,
      password: await hashPassword(REPORTER1_PASSWORD),
      role: 'REPORTER',
    },
  });

  console.log(`Seeded approver 1 user: ${REPORTER1_EMAIL}`);

  await prisma.user.upsert({
    where: { email: REPORTER2_EMAIL },
    update: {},
    create: {
      name: 'Reporter 2',
      email: REPORTER2_EMAIL,
      password: await hashPassword(REPORTER2_PASSWORD),
      role: 'REPORTER',
    },
  });

  console.log(`Seeded approver 2 user: ${REPORTER2_EMAIL}`);
}

main()
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
