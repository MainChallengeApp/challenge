import * as functionsTest from 'firebase-functions-test';
import { getLastMigration } from './collection/migrationsCollection';
import { Migration } from './migrations/migration';
import { createMockMigration } from './migrations/mockMigration';
import { runMigrationsDefinition } from './runMigrations';

const testEnv = functionsTest();

// Automatically uses the mock from __mocks__ directory
jest.mock('./collection/migrations_collection');
const mockGetLastMigration = getLastMigration as jest.Mock<Promise<Migration>>;

const request = {
  data: {},
  rawRequest: {} as any,
  acceptsStreaming: false
};

describe('runMigrations', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('should run migrations when newer migrations exist', async () => {
    const lastMigration = createMockMigration({ migrationNumber: 0 });
    mockGetLastMigration.mockResolvedValue(lastMigration);
    const result = await testEnv.wrap(runMigrationsDefinition)(request);
    expect(result).toBe('Migrations run successfully');
  });

  it('should not run migrations when all are up to date', async () => {
    const lastMigration = createMockMigration({ migrationNumber: 1 });
    mockGetLastMigration.mockResolvedValue(lastMigration);
    const result = await testEnv.wrap(runMigrationsDefinition)(request);
    expect(result).toBe('Migrations run successfully');
  });

  afterAll(() => {
    testEnv.cleanup();
  });
}); 