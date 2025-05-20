import { faker } from '@faker-js/faker';
import { Migration } from './migration';

export const createMockMigration = (overrides?: Partial<Migration>): Migration => {
  return new Migration(
    overrides?.migrationNumber ?? faker.datatype.number({ min: 1, max: 1000 }),
    overrides?.description ?? faker.lorem.sentence(),
    overrides?.appVersion ?? faker.system.semver(),
    overrides?.createdAt ?? faker.date.past()
  );
};
